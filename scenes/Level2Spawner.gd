extends Node

enum {STATE_IDLE, STATE_RANDOM_SPAWN, STATE_SWEEP, MIDDLE_PULSE_RANDOM_SPAWN, MINE_SPAWN }

var lastSpawn = 0;

var currentSpawnRate = 0;

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
var mineSpawnerScene = preload("res://objects/MineSpawner.tscn")

var levelData = [
	{ "ends": 10, "state": STATE_IDLE },
	# a few mines
	{ "ends": 30000, "state": MINE_SPAWN, "maxConcurrentMines": 1, "minConcurrentMines": 1, "spawnRate": 2000, "isHorizontal": true },
	{ "ends": 100000, "state": STATE_IDLE }
]

func _ready():
	rng.randomize()

func startLevel():
	currentStep = 0;
	currentState = STATE_IDLE;
	lastSpawn = 0;
	isStateInit = false;
	print("starting leve....")
	
	
func doProcess(timeElapsed):
	isStateInit = false;
	var timeNow = OS.get_ticks_msec()
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
	elif currentState == MINE_SPAWN:
		doMineSpawn(timeElapsed)
	else:
		print("!!!!oops!!!")
	
	
	
func doMineSpawn(timeElapsed):
	if timeElapsed - lastSpawn > levelData[currentStep]["spawnRate"]:
		var minConcurrentMines = levelData[currentStep]["minConcurrentMines"]
		var maxConcurrentMines = levelData[currentStep]["maxConcurrentMines"]
		# how many mines to spawn at once
		var num = rng.randi_range(minConcurrentMines, maxConcurrentMines)

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
			var newMine = mineSpawnerScene.instance()
			if levelData[currentStep]["isHorizontal"]:
				newMine.setAdvanced()
			#newBomb.position.x = rng.randi_range(200,get_viewport().size.x - 200)
			newMine.position.x = currentX
			add_child(newMine)
			currentX = currentX + width
		lastSpawn = timeElapsed
	
