extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export (int) var speed = 800

var movement = Vector2()

var max_scale = 1.5
var min_scale = 0.5

func get_input():
	movement = Vector2()
	if Input.is_action_pressed("right"):
		movement.x += 1
	if Input.is_action_pressed("left"):
		movement.x -= 1
	if Input.is_action_pressed("down"):
		if scale.x > min_scale:
			scale.x *= 0.95
	if Input.is_action_pressed("up"):
		if scale.x < max_scale:
			scale.x *= 1.05
	movement = movement.normalized() * speed
	if position.x >= get_viewport().size.x:
		position.x = 0;
	elif position.x < 0:
		position.x = get_viewport().size.x

func _physics_process(delta):
	get_input()
	move_and_slide(movement)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.collider.name)
#		collision.collider.explode()
