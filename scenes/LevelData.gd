extends Node


enum {STATE_IDLE, STATE_RANDOM_SPAWN, STATE_SWEEP, MIDDLE_PULSE_RANDOM_SPAWN}

var lastSpawn = 0;

var currentSpawnRate = 0;

var levelStart = 0;
var currentLevel = 0;
var currentStep = 0;

# if we need to do any init on the next state, set to false
# (set sweep direction, etc)
var isStateInit = false;

var currentState = STATE_IDLE;

var rng = RandomNumberGenerator.new()

var vertBombScene = preload("res://objects/VertBomb.tscn")


var levels = [
	[
		# a few lasers
		{ "ends": 1000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 1, "spawnRate": 1000 },
		# more, sometimes 2 at once
		{ "ends": 10000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 2,  "spawnRate": 1000 },
		# more, sometimes 3 at once
		{ "ends": 20000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 3,  "spawnRate": 1000 },
		# rising action
		{ "ends": 30000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 3,  "spawnRate": 500 },
		# going for it -- sweeps, 12 pulses per second
		{ "ends": 40000, "state": STATE_SWEEP, "spawnRate": 150 },
		# double sweeps
		{ "ends": 50000, "state": STATE_SWEEP, "spawnRate": 150 },
		# bunch of lasers, sometimes 3 at once
		{ "ends": 60000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 3, "spawnRate": 500 },
		# middle pullse and side lasers
		{ "ends": 70000, "state": MIDDLE_PULSE_RANDOM_SPAWN, "spawnRate": 500 },
		# more sweeps
		{ "ends": 80000, "state": STATE_SWEEP, "spawnRate": 150 },
		# spawn 3-5 at once
		{ "ends": 90000, "state": STATE_RANDOM_SPAWN, "maxConcurrentLasers": 5, "minConcurrentLasers": 3, "spawnRate": 500},
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
	isStateInit = false;
	
	
func _process(delta):
	var timeNow = OS.get_ticks_msec()
	var timeElapsed = timeNow - levelStart
	if timeElapsed > levels[currentLevel][currentStep]["ends"]:
		print("switching to new state")
		currentStep += 1
		isStateInit = true;
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
	elif currentState == MIDDLE_PULSE_RANDOM_SPAWN:
		doMiddlePulseRandomSpawn(timeElapsed)
	
	
	
func doRandomSpawn(timeElapsed):
#    var x_1 = random(global.area_width);
#    var x_2 = random(global.area_width);
#    var x_begin = min(x_1, x_2);
#    var x_end = max(x_1, x_2);
#    var width = x_end - x_begin;
#    //how many lasers to spawn
#    var num = random(2)+2;
#    if (width &lt; num * global.min_sine_width) {
#        num = 1;
#    }
 #   {
 #   var i;
 #   for (i = 0; i &lt; num; i += 1)
 #      {
 #      instance_create(width/num * i + x_begin, 0, obj_mine);
 #      }
 #   }
	if timeElapsed - lastSpawn > levels[currentLevel][currentStep]["spawnRate"]:
		var minConcurrentLasers = 1
#		if levels[currentLevel][currentStep]["minConcurrentLasers"] != null:
#			minConcurrentLasers = levels[currentLevel][currentStep]["minConcurrentLasers"]
		var maxConcurrentLasers = 1
		if levels[currentLevel][currentStep]["maxConcurrentLasers"] != null:
			maxConcurrentLasers = levels[currentLevel][currentStep]["maxConcurrentLasers"]
		# how many mines to spawn
		var num = rng.randi_range(minConcurrentLasers, maxConcurrentLasers)

		var x1 = rng.randi_range(0,get_viewport().size.x)
		var x2 = rng.randi_range(0,get_viewport().size.x)
		var xLeft = min(x1, x2)
		var xRight = max(x1, x2)
		var width = xRight - xLeft
		#TODO: finish spawning multiple, ensure width is not too smallish
		#if width - 
		print("Spawning")
		var newBomb = vertBombScene.instance()
		newBomb.position.x = rng.randi_range(200,get_viewport().size.x - 200)
		add_child(newBomb)
		lastSpawn = timeElapsed
	

func doSweep(timeElapsed):
	pass

func doMiddlePulseRandomSpawn(timeElapsed):
	pass
