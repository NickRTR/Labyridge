extends Node

onready var on_screen = $UI
onready var level = SaveGame.data["current_level"]

func _ready():
	load_menu()


func _physics_process(delta):
	if on_screen.name == "UI":
		if Input.is_action_just_pressed("ui_accept"):
			play()
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			reload_menu()
	
	if on_screen.name == "Levels":
		if $Levels.return_level() != null:
			SaveGame.data["current_level"] = $Levels.return_level() 
			SaveGame.save_game()
			SaveGame.load_game()
			play()


func load_menu():
	on_screen = $UI
	get_node("UI/VBoxContainer/New").connect("pressed", self, "new_game")
	get_node("UI/VBoxContainer/Play").connect("pressed", self, "play")
	get_node("UI/VBoxContainer/Levels").connect("pressed", self, "levels")
	get_node("UI/VBoxContainer/Quit").connect("pressed", self, "quit")


func new_game():
	$Button.play()
	SaveGame.reset_data()
	SaveGame.load_game()
	play()


func play():
	$Button.play()
	level = SaveGame.data["current_level"]
	if level > SaveGame.data["level_count"]:
		on_screen.queue_free()
		var end_scene = load("res://Scenes/UI/EndScene.tscn").instance()
		add_child(end_scene)
		on_screen = $EndScene
	else:
		on_screen.queue_free()
		var game = load("res://Scenes/Main/Game.tscn").instance()
		add_child(game)
		on_screen = $Game
		$Game/Player.connect("dead", self, "reload_menu")
		$Game/Player.connect("win", self, "win")


func levels():
	$Button.play()
	$UI.queue_free()
	var levels = load("res://Scenes/UI/Levels.tscn").instance()
	add_child(levels)
	on_screen = $Levels


func reload_menu():
	on_screen.queue_free()
	var ui = load("res://Scenes/UI/UI.tscn").instance()
	add_child(ui)
	load_menu()


func win():
	on_screen.name = "UI"
	SaveGame.next_level()
	play()


func quit():
	get_tree().quit()
