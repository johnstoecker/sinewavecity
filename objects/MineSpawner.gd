extends Area2D


var movement = Vector2(0, 1)
var speed = 100
var lastSpawn
var hasStopped = false
# TODO: variable spawn rate
var spawnRate = 500
var vertBombScene = preload("res://objects/VertBomb.tscn")
var hasCollidedWithSineWave = false
var hasCollidedWithCity = false
var hasCollidedWithRailGunner = false
var hasCollidedWithVertRailGunner = false
var hasCollidedWithHorizRailGunner = false

var isAdvanced = false
var isHalfHealth = false

func setAdvanced():
	isAdvanced = true

# Called when the node enters the scene tree for the first time.
func _ready():
	movement = movement.normalized() * speed
	if isAdvanced:
		$AnimatedSprite.play("fullSprite")
	else:
		$AnimatedSprite.play("default")
	var timeNow = OS.get_ticks_msec()
	lastSpawn = timeNow
	connect("body_entered", self, "_on_Area_body_entered")

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

# the mine spawner moves to the middle-ish of the screen and starts spawning lasers until hit
func _physics_process(delta):
	var timeNow = OS.get_ticks_msec()
	if position.y >= get_viewport().size.y/4:
		movement = Vector2(0,0)
		hasStopped = true
	else:
		position.y = position.y + delta * speed
		

	var floor_normal = Vector2(0, 0)
	var slope_min_velocity = 5
	var max_bounces = 1
	var floor_max_angle = PI/4

	if isAdvanced && !isHalfHealth && (hasCollidedWithHorizRailGunner || hasCollidedWithVertRailGunner):
		setHalfHealth()

	if hasCollidedWithCity:
		explode()
		get_tree().get_root().get_child(0).hit()
		set_physics_process(false)
	elif hasCollidedWithSineWave || (hasCollidedWithRailGunner && !isAdvanced) || (isAdvanced && hasCollidedWithHorizRailGunner && hasCollidedWithVertRailGunner):
		explode()
		set_physics_process(false)
	elif hasStopped && timeNow - lastSpawn > spawnRate:
		if isAdvanced && !hasCollidedWithHorizRailGunner:
			var newBomb = vertBombScene.instance()
			newBomb.setHorizontal(true)
			newBomb.rotate(PI / 2)
			newBomb.position.x = position.x + 35
			newBomb.position.y = position.y
			get_parent().add_child(newBomb)
			lastSpawn = timeNow
			
		if !hasCollidedWithVertRailGunner:
			var newBomb = vertBombScene.instance()
			newBomb.position.x = position.x
			newBomb.position.y = position.y + 35
			get_parent().add_child(newBomb)
			lastSpawn = timeNow

func remove():
	$Timer.start(1)
	$Timer.connect("timeout", self, "_on_timer_timeout")

func setHalfHealth():
	isHalfHealth = true
	if hasCollidedWithHorizRailGunner:
		$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.play("halfSprite")

func explode():
	print("exploding mine spawner!!!")
	movement.x = 0
	movement.y = 0
	$Sprite.visible = false	
	$CollisionPolygon2D.disabled = true
	$AnimatedSprite.play("explosion")
	remove()

func _on_timer_timeout():
	queue_free()
