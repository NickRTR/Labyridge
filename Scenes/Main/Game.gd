extends Node2D

onready var map = load("res://Scenes/Maps/Map" + String(SaveGame.data["current_level"]) + ".tscn").instance()

func _ready():
	add_child(map)
	move_child(map, 0)
	
	if SaveGame.data["current_level"] == 0:
		$Player.tutorial = true
	else:
		$Player.tutorial = false
