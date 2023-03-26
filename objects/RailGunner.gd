extends KinematicBody2D


var movement = Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(0.8)
	$Timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout():
	queue_free()
