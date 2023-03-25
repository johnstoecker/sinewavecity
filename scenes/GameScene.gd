extends Node2D


var current_level
var points = 100

func _ready():
	$CanvasLayer/Label.text = "Score: 100"
	pass

func hit():
	points -= 1
	$CanvasLayer/Label.text = "Score: "+str(points)

func start_game():
	$LevelSpawner.startLevel(2);
