extends Node2D


var can_show: = true

var newgame
var about
var loadgame
var blank_count = 0
var exit
var buddy

func _ready():
	#var buddy_scene = preload("res://Buddy.tscn")
	#buddy = buddy_scene.instance()
	#buddy.get_node("Label").text = "Welcome to the Electrician's Apprentice!\nClick New Game to start."
	#add_child(buddy)
	newgame = $Control/VBoxContainer/NewGame
	newgame.connect("pressed", self, "_on_new_game_pressed")
	loadgame = $Control/VBoxContainer/Levels
	loadgame.connect("pressed", self, "_on_leves_pressed")
	about = $Control/VBoxContainer/Settings
	about.connect("pressed", self, "_on_settings_pressed")
	exit = $Control/VBoxContainer/Exit
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_new_game_pressed():
	get_owner().saveLevel(1)
	get_owner().startGame()

func _on_levels_pressed():
	get_owner().startGame()

func _on_settings_pressed():
	pass
	#buddy.get_node("Label").text = "code: stoecker\ncode: vzhou\nassets: gashley\nlevels: antonio"

func _on_exit_pressed():
	get_tree().quit()
