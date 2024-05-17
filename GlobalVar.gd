extends Node
var Difficulty
var score = 0
var GameLevel = 0 # 0, 1, 2 for easy normal hard


var http_url: String
var translate: bool
var asr_url: String
const default_url = "http://127.0.0.1:6666/"
const default_translate = true
const default_asr_url = "tcp://127.0.0.1:43007"

signal sentences_received(sentences)
signal translations_received(translations)

# Our WebSocketClient instance.
var sentences_client
var translations_client
func _ready():

	var config = ConfigFile.new()
	var err = config.load("user://config.save")
	if err == OK:
		GlobalVar.http_url = config.get_value("config","url")
		GlobalVar.translate = config.get_value("config","translate")
		GlobalVar.asr_url = config.get_value("config","asr_url")
		print(GlobalVar.http_url+"\t"+str(GlobalVar.translate))
		if GlobalVar.http_url==null || GlobalVar.http_url == "":
			GlobalVar.http_url = GlobalVar.default_url
			print("use default url")
		if GlobalVar.translate==null :
			GlobalVar.translate = GlobalVar.default_translate
			print("use default translate")
		if GlobalVar.asr_url==null || GlobalVar.asr_url == "":
			GlobalVar.asr_url = GlobalVar.default_asr_url
			print("use default asr url")
	else :
		GlobalVar.http_url = GlobalVar.default_url
		GlobalVar.translate = GlobalVar.default_translate
		GlobalVar.asr_url = GlobalVar.default_asr_url
		print("config file not found")
		config.set_value("config","url",GlobalVar.http_url)
		config.set_value("config","translate",GlobalVar.translate)
		config.set_value("config","asr_url",GlobalVar.asr_url)
		config.save("user://config.save")

	sentences_client = HTTPRequest.new()
	translations_client = HTTPRequest.new()
	add_child(sentences_client)
	add_child(translations_client)
	sentences_client.connect("request_completed", self, "_on_sentences_received")
	translations_client.connect("request_completed", self, "_on_translations_received")

func _on_sentences_received(_result, response_code, _headers, body):
#	print(str(_result)+'\n')
#	print(str(response_code)+'\n')
#	print(str(_headers))
#	print(body.get_string_from_utf8()+"\n")
	if response_code!=200:
		push_error("server connection problem")
	emit_signal("sentences_received", body.get_string_from_utf8())

func _on_translations_received(_result, response_code, _headers, body):
#	print(str(_result)+'\n')
#	print(str(response_code)+'\n')
#	print(str(_headers))
#	print(body.get_string_from_utf8()+"\n")
	if response_code!=200:
		push_error("server connection problem")

	emit_signal("translations_received", body.get_string_from_utf8())

func get_sentences():
	var fun = "sentences"
	var error = sentences_client.request(http_url+fun)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
func get_translations():
	var fun = "translations"
	var error = translations_client.request(http_url+fun)
#	var error = translations_client.request("http://127.0.0.1:6666/sentences")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
func _process(_delta):
	pass
	
func _exit_tree():
	pass
