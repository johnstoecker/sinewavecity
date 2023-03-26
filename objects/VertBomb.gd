extends KinematicBody2D


var movement = Vector2(0, 1)
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	movement = movement.normalized() * speed

func _physics_process(delta):
	move_and_slide(movement)
	var hasCollidedWithSineWave = false
	var hasCollidedWithCity = false
	var hasCollidedWithRailGunner = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print(collision.collider.name)
		# dont care about colliding with other lasers
		if collision.collider.name == "SineWave":
			hasCollidedWithSineWave = true
		if collision.collider.name == "CityCollision":
			hasCollidedWithCity = true
		if collision.collider.name.find("Railgunner") != -1:
			hasCollidedWithRailGunner= true
			
	if hasCollidedWithCity:
		destroy()
		get_tree().get_root().get_child(0).get_child(0).hit()
		set_physics_process(false)
	elif hasCollidedWithSineWave || hasCollidedWithRailGunner:
		explode()
		set_physics_process(false)

func remove():
	$Timer.start(1)
	$Timer.connect("timeout", self, "_on_timer_timeout")

func destroy():
	print("destroying!!!")
	$SndDestroy.play()
#	movement.x = 0
#	movement.y = 0
	$Sprite.visible = false	
	$AnimatedSprite.visible = true
	$CollisionPolygon2D.disabled = true
	# TODO: why is this not going
	$AnimatedSprite.play("destroy")
	remove()
	

func explode():
	print("exploding!!!")
	$SndDefend.play()
	movement.x = 0
	movement.y = 0
	$Sprite.visible = false	
	$AnimatedSprite.visible = true
	$CollisionPolygon2D.disabled = true
	# TODO: why is this not going
	$AnimatedSprite.play("explosion")
	remove()

func _on_timer_timeout():
	queue_free()
