extends Node


enum {STATE_IDLE, STATE_RANDOM_SPAWN, STATE_CONCURRENT_SPAWN, STATE_SWEEP}

var lastSpawn = 0;

var currentSpawnRate = 0;

var levelStart = 0;
var currentLevel = 0;
var currentStep = 0;

var currentState = STATE_IDLE;

var rng = RandomNumberGenerator.new()

var vertBombScene = preload("res://objects/VertBomb.tscn")

var levels = [
	[
		{ "ends": 1000, "state": STATE_IDLE },
		{ "ends": 10100, "state": STATE_RANDOM_SPAWN, "spawnRate": 1000 },
		{ "ends": 20000, "state": STATE_IDLE }
	]
]

func _ready():
	rng.randomize()
	startLevel(0)


func startLevel(level):
	levelStart = OS.get_ticks_msec()
	currentLevel = 0;
	currentStep = 0;
	currentState = STATE_IDLE;
	lastSpawn = 0;
	
	
func _process(delta):
	var timeNow = OS.get_ticks_msec()
	var timeElapsed = timeNow - levelStart
	if timeElapsed > levels[currentLevel][currentStep]["ends"]:
		print("switching to new state")
		currentStep += 1
		if currentStep >= levels[currentLevel].size():
			currentState = STATE_IDLE
			# TODO: go to next level
			startLevel(0)
		else:
			currentState = levels[currentLevel][currentStep]["state"]

	if currentState == STATE_IDLE:
		pass
	elif currentState == STATE_RANDOM_SPAWN:
		doRandomSpawn(timeElapsed)
	elif currentState == STATE_SWEEP:
		doSweep(timeElapsed)
	
	
func doRandomSpawn(timeElapsed):
	if timeElapsed - lastSpawn > levels[currentLevel][currentStep]["spawnRate"]:
		print("Spawning")
		var newBomb = vertBombScene.instance()
		newBomb.position.x = rng.randi_range(200,get_viewport().size.x - 200)
		add_child(newBomb)
		lastSpawn = timeElapsed
	

func doSweep(timeElapsed):
	pass
