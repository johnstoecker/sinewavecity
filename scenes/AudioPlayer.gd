extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func startLevel(level):
	playSound(level)

func playSound(level):
	stopSound()
	getReferenceForLevel(level).play()

# ehh just stop em all
func stopSound():
	$SndAdmiralBob.stop()
	$SndNoArtificialFlavoring.stop()
	$SndNightLights.stop()
	$SndBushWeek.stop()

func pauseSound(level):
	getReferenceForLevel(level).pause()
	
func unPauseSound(level):
	getReferenceForLevel(level).play()

func getReferenceForLevel(level):
	if level == 1:
		return $SndAdmiralBob
	elif level == 2:
		return $SndNoArtificialFlavoring
	elif level == 3:
		return $SndNightLights
	elif level == 4:
		return $SndBushWeek
	return null
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
