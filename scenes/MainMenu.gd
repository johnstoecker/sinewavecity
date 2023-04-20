extends Node2D


var can_show: = true

var newgame
var about
var loadgame
var blank_count = 0
var exit
var buddy

func _ready():
	newgame = $Control/VBoxContainer/NewGame
	newgame.connect("pressed", self, "_on_new_game_pressed")
	loadgame = $Control/VBoxContainer/Levels
	loadgame.connect("pressed", self, "_on_levels_pressed")
	about = $Control/VBoxContainer/Settings
	about.connect("pressed", self, "_on_settings_pressed")
	exit = $Control/VBoxContainer/Exit
	exit.connect("pressed", self, "_on_exit_pressed")
	$Control/VBoxContainer/NewGame.grab_focus()
#	allow main scene to process even when "paused"
	pause_mode = Node.PAUSE_MODE_PROCESS

func _on_new_game_pressed():
	print("new game press")
	get_owner().starLevel(1)

func _on_levels_pressed():
	get_owner().showLevelsMenu()

func _on_settings_pressed():
	pass
	#buddy.get_node("Label").text = "code: stoecker\ncode: vzhou\nassets: gashley\nlevels: antonio"

func _on_exit_pressed():
	get_tree().quit()
