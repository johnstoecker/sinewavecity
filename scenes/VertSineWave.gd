extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentWaveWidth = 100
var originalWidth = 100
var xStart = 500
var lastRailgunFire = 0

var railGunnerScene = preload("res://objects/RailGunner.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	xStart = position.x
	originalWidth = $Sprite.texture.get_width()/12 * 0.5
	currentWaveWidth = originalWidth

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
	if Input.is_action_pressed("space"):
		fireRailGun()
	movement = movement * speed
	position.y += movement

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

func fireRailGun():
	if !visible:
		return
	var timeNow = OS.get_ticks_msec()
	var timeElapsed = timeNow - lastRailgunFire
	# TODO: constant for railgun cooldown
	if timeElapsed > 300:
		print(currentWaveWidth)
		lastRailgunFire = timeNow
		# 12 sine wave peaks
		for i in 12:
			var newRailGunner = railGunnerScene.instance()
			newRailGunner.setHorizontal(true)
#			TODO: make not a constant
			newRailGunner.position.x = position.x - 500
			newRailGunner.position.y = position.y + currentWaveWidth*(i-6)
			newRailGunner.rotate(PI / 2)
			get_parent().add_child(newRailGunner)


