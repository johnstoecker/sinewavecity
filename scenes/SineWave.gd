extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentWaveWidth = 100
var originalWidth = 100
var xStart = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	xStart = position.x
	originalWidth = $Sprite.texture.get_width()/12 * 0.5
	currentWaveWidth = originalWidth
	pass # Replace with function body.

export (int) var speed = 5

var movement = Vector2()

var max_scale = 1.5
var min_scale = 0.5


func get_input():
	movement = 0
	if Input.is_action_pressed("right"):
		movement += 1
	if Input.is_action_pressed("left"):
		movement -= 1
	if Input.is_action_pressed("down"):
		if scale.x > min_scale:
			scale.x *= 0.95
			currentWaveWidth = originalWidth * scale.x
	if Input.is_action_pressed("up"):
		if scale.x < max_scale:
			scale.x *= 1.05
			currentWaveWidth = originalWidth * scale.x
	movement = movement * speed
	position.x += movement
	

	# 12 peaks, if its past the 3rd peak, set to 0
	# if its before the 3rd peak, set to 0
	if position.x > xStart + currentWaveWidth:
		print("resetting left")
		position.x = position.x - currentWaveWidth
	elif position.x < xStart - currentWaveWidth:
		print("resetting right")
		position.x = position.x + currentWaveWidth

#if (x&gt;=xstart+sprite_width/12) {
#  x = xstart;
#}
#else if (x&lt;=xstart-sprite_width/12) {
#  x= xstart;
#}

func _physics_process(delta):
	get_input()
#	move_and_slide(movement)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print("Collided with: ", collision.collider.name)
##		collision.collider.explode()
