extends Node

enum {STATE_IDLE, STATE_RANDOM_SPAWN, STATE_SWEEP, MIDDLE_PULSE_RANDOM_SPAWN}

var lastSpawn = 0;

var currentSpawnRate = 0;

var levelStart = 0
var currentStep = 0;

# if we need to do any init on the next state, set to false
# (set sweep direction, etc)
var isStateInit = false;

# sweep vars
# current sweep spawn position
var currentSweepX = 250;
# sweeping left or right? 1 = right, -1 = left
var currentSweepDirection = 1;
var lastRandomSweepDirectionSwitch = 0;

# middle pulse vars
var middlePulseX;
var lastMiddleSpawn = 0;

var currentState = STATE_IDLE;

var rng = RandomNumberGenerator.new()

var vertBombScene = preload("res://objects/VertBomb.tscn")


var levelData = [
	{ "ends": 10, "state": STATE_IDLE },
	# a few lasers
	{ "ends": 1000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 1, "minConcurrentLasers": 1, "spawnRate": 1000 },
	# more, sometimes 2 at once
	{ "ends": 10000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 2,  "minConcurrentLasers": 1, "spawnRate": 1000 },
	# more, sometimes 3 at once
	{ "ends": 20000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 3, "minConcurrentLasers": 1,  "spawnRate": 1000 },
	# rising action
	{ "ends": 30000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 3,  "minConcurrentLasers": 1, "spawnRate": 500 },
	# going for it -- sweeps
	{ "ends": 40000, "state": STATE_SWEEP, "spawnRate": 150 },
	# double sweeps
	{ "ends": 50000, "state": STATE_SWEEP, "spawnRate": 150 },
	# bunch of lasers, sometimes 3 at once
	{ "ends": 60000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 3, "minConcurrentLasers": 1, "spawnRate": 500 },
	# middle pulse and side lasers
	{ "ends": 70000, "state": MIDDLE_PULSE_RANDOM_SPAWN, "spawnRate": 500, "maxConcurrentLasers": 2, "minConcurrentLasers": 2, "pulseSpawnRate": 150 },
	# more sweeps
	{ "ends": 80000, "state": STATE_SWEEP, "spawnRate": 150 },
	# spawn 3-5 at once
	{ "ends": 90000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 5, "minConcurrentLasers": 3, "spawnRate": 500},
	{ "ends": 100000, "state": STATE_IDLE }
]

func _ready():
	rng.randomize()

func startLevel():
	print("starting level...")
	levelStart = OS.get_ticks_msec()
	currentStep = 0;
	currentState = STATE_IDLE;
	lastSpawn = 0;
	isStateInit = false;
	print("starting leve....")
	
	
func doProcess():
	isStateInit = false;
	var timeNow = OS.get_ticks_msec()
	var timeElapsed = timeNow - levelStart
	if timeElapsed > levelData[currentStep]["ends"]:
		print("switching to new state")
		currentStep += 1
		isStateInit = true;
		if currentStep >= levelData.size():
			currentState = STATE_IDLE
			# TODO: go to next level
			get_parent().finish_level()
		else:
			currentState = levelData[currentStep]["state"]
	if currentState == STATE_IDLE:
		pass
	elif currentState == STATE_RANDOM_SPAWN:
		doRandomSpawn(timeElapsed)
	elif currentState == STATE_SWEEP:
		doSweep(timeElapsed)
	elif currentState == MIDDLE_PULSE_RANDOM_SPAWN:
		doMiddlePulseRandomSpawn(timeElapsed)
	else:
		print("!!!!oops!!!")
	
	
	
func doRandomSpawn(timeElapsed):
	if timeElapsed - lastSpawn > levelData[currentStep]["spawnRate"]:
		var minConcurrentLasers = levelData[currentStep]["minConcurrentLasers"]
		var maxConcurrentLasers = levelData[currentStep]["maxConcurrentLasers"]
		# how many mines to spawn at once
		var num = rng.randi_range(minConcurrentLasers, maxConcurrentLasers)

		var x1 = rng.randi_range(0,get_viewport().size.x)
		var x2 = rng.randi_range(0,get_viewport().size.x)
		# get leftmost laser x pos
		var xLeft = min(x1, x2)
		# get rightmost laser x pos
		var xRight = max(x1, x2)
		var width = (xRight - xLeft)
		
		# get spacing between each laser, avoid dividing by zero
		if num > 1:
			width = width/(num-1)
		# TODO: min width between concurrent lasers?
		if width < 30:
			# increase the width between lasers so the sine wave can actually catch them all
			width = width + 30
		var currentX = xLeft;
		for n in num:
			var newBomb = vertBombScene.instance()
			#newBomb.position.x = rng.randi_range(200,get_viewport().size.x - 200)
			newBomb.position.x = currentX
			add_child(newBomb)
			currentX = currentX + width
		lastSpawn = timeElapsed
	

func doSweep(timeElapsed):
	# find starting x
	if isStateInit:
		# sweeps start somewhere middle-ish of the screen
		currentSweepX = get_viewport().size.x * 0.2 + rng.randi_range(0,get_viewport().size.x * 0.4)
		var directions = [-1, 1]
		currentSweepDirection = directions[rng.randi()%2]

	if timeElapsed - lastSpawn > levelData[currentStep]["spawnRate"]:
		var newBomb = vertBombScene.instance()
		newBomb.position.x = currentSweepX
		add_child(newBomb)
		
		# X sweep interval = 20
		# TODO: make a constant
		currentSweepX = currentSweepX + 20*currentSweepDirection
		lastSpawn = timeElapsed
	
	# if we are about to hit a side, switch directions
	if currentSweepX < get_viewport().size.x * 0.1 || currentSweepX > get_viewport().size.x * 0.9:
		currentSweepDirection = -currentSweepDirection
	# TODO: sometimes randomly switch direction
	#elif (timeElapsed - lastRandomSweepDirectionSwitch > 400) && rng.randi()%30 > 28:
#		currentSweepDirection = -currentSweepDirection
#		lastRandomSweepDirectionSwitch = timeElapsed

func doMiddlePulseRandomSpawn(timeElapsed):
	doRandomSpawnForMiddlePulse(timeElapsed)
	if isStateInit:
		middlePulseX = get_viewport().size.x /2
	if timeElapsed - lastMiddleSpawn > levelData[currentStep]["pulseSpawnRate"]:
		var newBomb = vertBombScene.instance()
		newBomb.position.x = middlePulseX
		add_child(newBomb)
		lastMiddleSpawn = timeElapsed
		
func doRandomSpawnForMiddlePulse(timeElapsed):
	if timeElapsed - lastSpawn > levelData[currentStep]["spawnRate"]:
		# how many mines to spawn at once
		var num = 2

		# left side position
		var x1 = rng.randi_range(0,get_viewport().size.x)/2
		# TODO: 20 should be a constant
		if get_viewport().size.x- x1 < 50:
			# increase the width between lasers so the sine wave can actually catch them all
			x1 = x1 - 50
			
		# right side position
		var x2 = get_viewport().size.x - x1
		var newBombL = vertBombScene.instance()
		newBombL.position.x = x1
		add_child(newBombL)

		var newBombR = vertBombScene.instance()
		newBombR.position.x = x2
		add_child(newBombR)

		lastSpawn = timeElapsed
