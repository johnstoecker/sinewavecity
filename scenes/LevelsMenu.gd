extends Node2D


var can_show: = true

var newgame
var about
var loadgame
var blank_count = 0
var exit
var buddy

func _ready():
	$Control/VBoxContainer/Level1.connect("pressed", self, "_on_level1_pressed")
	$Control/VBoxContainer/Level2.connect("pressed", self, "_on_level2_pressed")
	$Control/VBoxContainer/Level3.connect("pressed", self, "_on_level3_pressed")
	$Control/VBoxContainer/Level4.connect("pressed", self, "_on_level4_pressed")
#	allow main scene to process esven when "paused"
#	pause_mode = Node.PAUSE_MODE_PROCESS

func _on_level1_pressed():
	get_owner().starLevel(1)

func _on_level2_pressed():
	get_owner().starLevel(2)
func _on_level3_pressed():
	get_owner().starLevel(3)
func _on_level4_pressed():
	get_owner().starLevel(4)



