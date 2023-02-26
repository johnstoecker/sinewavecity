extends KinematicBody2D


var movement = Vector2(0, 1)
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	movement = movement.normalized() * speed

func _physics_process(delta):
	move_and_slide(movement)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		# dont care about colliding with other lasers
		if collision.collider.name == "SineWave":
			explode()
	if position.y > get_viewport().size.y + 20:
		set_physics_process(false)
		remove()
		get_tree().get_root().get_child(0).get_child(0).hit()
		#TODO: game over

func remove():
	$Timer.start(1)
	$Timer.connect("timeout", self, "_on_timer_timeout")

func explode():
	print("exploding!!!")
	movement.x = 0
	movement.y = 0
	$Sprite.visible = false	
	$CollisionPolygon2D.disabled = true
	# TODO: why is this not going
	$AnimatedSprite.play("explosion")
	remove()

func _on_timer_timeout():
	queue_free()
