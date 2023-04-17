extends Node

enum {STATE_IDLE, STATE_RANDOM_SPAWN, STATE_SWEEP, MIDDLE_PULSE_RANDOM_SPAWN}

var lastSpawn = 0;

var currentSpawnRate = 0;

var levelStart = 0;
var currentLevel = -1;
var currentStep = 0;

#keep track of current pause time
var currentPauseTime

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


var levelObjects = []
var currentLevelObject

func _ready():
	rng.randomize()
	levelObjects = [$Level1Spawner, $Level2Spawner, $Level3Spawner]
	currentLevelObject = $Level1Spawner

func startLevel(level):
	currentLevelObject = levelObjects[level-1]	
	levelStart = OS.get_ticks_msec()
	currentLevel = level;
	currentStep = 0;
	currentState = STATE_IDLE;
	lastSpawn = 0;
	isStateInit = false;
	
func pauseLevel(level):
	currentPauseTime = OS.get_ticks_msec()
	currentLevelObject = levelObjects[level-1]
	currentLevelObject.pause()

func unPauseLevel(level):
	var unPauseTime = OS.get_ticks_msec()
	var pauseElapsed = unPauseTime - currentPauseTime
	levelStart = levelStart + pauseElapsed
	currentPauseTime = null
	currentLevelObject = levelObjects[level-1]
	currentLevelObject.unPause()

func stop():
	currentLevel = -1;
	
func _process(delta):
	var timeNow = OS.get_ticks_msec()
	var timeElapsed = timeNow - levelStart
	if currentLevel == -1:
		return
	currentLevelObject.doProcess(timeElapsed)
	
func finish_level():
	# TODO: next level
	# startLevel(...)
	pass
	
