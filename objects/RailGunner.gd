extends KinematicBody2D


var movement = Vector2(0, 1)
var horizontal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(0.8)
	$Timer.connect("timeout", self, "_on_timer_timeout")
	connect("body_entered", self, "_on_Area_body_entered")

func setHorizontal(val):
	horizontal = val

func isHorizontal():
	return horizontal

func _on_Area_body_entered(body:Node) -> void:
	print("body entered!!!")
	print(body)

func _on_timer_timeout():
	queue_free()
