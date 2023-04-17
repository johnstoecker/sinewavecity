extends Area2D


var movement = Vector2(0, 1)
var speed = 200
var hasCollidedWithSineWave = false
var hasCollidedWithCity = false
var hasCollidedWithRailGunner = false
var hasCollidedWithVertRailGunner = false
var hasCollidedWithHorizRailGunner = false
var isHorizontal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	movement = movement.normalized() * speed
	connect("body_entered", self, "_on_Area_body_entered")

func setHorizontal(val):
	isHorizontal = true

func _on_Area_body_entered(body:Node) -> void:
	# dont care about colliding with other lasers
	if body.name == "SineWave":
		hasCollidedWithSineWave = true
	if body.name == "CityCollision":
		hasCollidedWithCity = true
	if body.name.find("Railgunner") != -1:
		hasCollidedWithRailGunner= true
		if body.isHorizontal():
			hasCollidedWithHorizRailGunner = true
		else:
			hasCollidedWithVertRailGunner = true

func _physics_process(delta):
	if isHorizontal:
		position.x = position.x + delta * speed
	else:
		position.y = position.y + delta * speed
#	move_and_slide(movement)
			
	if hasCollidedWithCity:
		destroy()
		get_tree().get_root().get_child(0).hit()
		set_physics_process(false)
	elif hasCollidedWithSineWave || (isHorizontal && hasCollidedWithHorizRailGunner) || (!isHorizontal && hasCollidedWithVertRailGunner):
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
