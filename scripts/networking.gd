class_name Networking extends Control

signal retrieve_scores
signal highest_score
signal failed_to_connect

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL : String = "http://localhost/highscore/high_score.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
const SECRET_KEY : String = "$n4kel1m1ted"
var nonce = null
var request_queue : Array = []
var is_requesting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Connect our request handler:
	add_child(http_request)
	http_request.connect("request_completed", http_request_completed)
	print("Networking Instantiated!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Check if we are good to send a request:
	if is_requesting:
		return
		
	if request_queue.is_empty():
		return
		
	is_requesting = true
	if nonce == null:
		request_nonce()
	else:
		send_request(request_queue.pop_front())


func http_request_completed(_result, _response_code, _headers, _body) -> void:
	is_requesting = false
	if _result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error w/ connection: " + String(_result))
		failed_to_connect.emit()
		return
		
	var response_body = _body.get_string_from_utf8()
	# Grab our JSON and handle any errors reported by our PHP code:
	var response = JSON.parse_string(response_body)
	if response['error'] != "none":
		printerr("We returned error: " + response['error'])
		return
	
	# Check if we were requesting a nonce:
	if response['command'] == 'get_nonce':
		nonce = response['response']['nonce']
		print("Got nonce: " + response['response']['nonce'])
		return
		
	if response['command'] == "get_scores":
		retrieve_scores.emit(response['response'])
		
	if response['command'] == "get_high_score":
		highest_score.emit(response['response'])
		
	# If not requesting a nonce, we handle all other requests here:
	print("Response Body:\n" + response_body)
	
func request_nonce() -> void:
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify({})})
	var body = "command=get_nonce&" + data
	
	# Make request to the server:
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	# Check if there were problems:
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
		
	print("Requesting nonce...")
	
func send_request(request: Dictionary) -> void:
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	# Generate our 'response nonce'
	var cnonce = Crypto.new().generate_random_bytes(32).get_string_from_utf8().sha256_text()
	
	# Generate our security hash:
	var client_hash = (nonce + cnonce + body + SECRET_KEY).sha256_text()
	nonce = null
	
	# Create our custom header for the request:
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	# Make request to the server:
	var err = http_request.request(SERVER_URL, headers, HTTPClient.METHOD_POST, body)
	
	# Check if there were problems:
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		failed_to_connect.emit()
		return
		
	# Print out request for debugging:
	print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)
	
func submit_score(score: int, username: String, level: int) -> void:	
	var command = "add_score"
	var data = {"score" : score, "username" : username, "level": level}
	request_queue.push_back({"command" : command, "data" : data})
	
func get_scores(level: int, offset: int = 0, limit: int = 10) -> void:
	var command = "get_scores"
	var data = {"score_level": level, "score_offset" : offset, "score_limit" : limit}
	request_queue.push_back({"command" : command, "data" : data});
	
func get_highest_score(level: int) -> void:
	var command = "get_high_score"
	var data = {"score_level" : level}
	request_queue.push_back({"command": command, "data" : data });
