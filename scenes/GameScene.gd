extends Node2D


var current_level
var points = 100

func _ready():
	$Score/Label.text = "Score: 100"
	pass

func hit():
	points -= 1
	$Score/Label.text = "Score: "+str(points)

# meta level stuff:
# level 1: just regular sine wave, lasers
# level 2: regular since wave, mine spawner + introduce beam
# level 3: vertical sine wave, double mine spawner
# level 4: spinny thing

func unpause():
	print("unpausing")

func pause():
	print("pausing")
#	$LevelSpawner.pauseLevel()
#	$AudioPlayer.pauseSound()

func stop():
	$AudioPlayer.stopSound()
	$LevelSpawner.stop()

func start_level(level):
	current_level = level
	if level == 1:
		$VertSineWave.visible = false
	elif level ==2:
		$VertSineWave.visible = false
	elif level ==3 :
		$VertSineWave.visible = true
	elif level ==4:
		$VertSineWave.visible = true
	$LevelSpawner.startLevel(level)
	$AudioPlayer.playSound(level)
