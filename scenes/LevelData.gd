extends Node

enum {STATE_IDLE, STATE_RANDOM_SPAWN, STATE_SWEEP, MIDDLE_PULSE_RANDOM_SPAWN}

var lastSpawn = 0;

var currentSpawnRate = 0;

var levelStart = 0;
var currentLevel = -1;
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


var levelObjects = []
var currentLevelObject

func _ready():
	rng.randomize()
	levelObjects = [$Level1Spawner, $Level2Spawner]
	currentLevelObject = $Level1Spawner

func startLevel(level):
	currentLevelObject = levelObjects[level-1]	
		
	print("starting level...")
	levelStart = OS.get_ticks_msec()
	currentLevel = level;
	currentStep = 0;
	currentState = STATE_IDLE;
	lastSpawn = 0;
	isStateInit = false;
	print("starting leve....")
	
	
func _process(delta):
	if currentLevel == -1:
		return
	currentLevelObject.doProcess()
	
func finish_level():
	# TODO: next level
	# startLevel(...)
	pass
	
