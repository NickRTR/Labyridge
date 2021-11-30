extends Node

var path = "user://data.json"

# The default values
var default_data = {
	"level_count": 8,
	"current_level": 0,
}

var data = {}

func _ready():
	load_game()


func load_game():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
		
	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	data = parse_json(text)
	
	
	file.close()


func save_game():
	var file
	
	file = File.new()
	
	file.open(path, File.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()


func reset_data():
	data = default_data.duplicate(true)
	save_game()


func next_level():
	data["current_level"] += 1
	if data["current_level"] == 1:
		data["tutorial_absolved"] = true
	save_game()
