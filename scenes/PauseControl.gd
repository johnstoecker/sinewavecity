extends Control


var can_show: = true

var newgame
var about
var loadgame
var blank_count = 0
var exit
var buddy

func _ready():
	newgame = $VBoxContainer/Resume
	newgame.connect("pressed", self, "_on_resume_pressed")
	exit = $VBoxContainer/Exit
	exit.connect("pressed", self, "_on_exit_pressed")
#	allow main scene to process even when "paused"
	pause_mode = Node.PAUSE_MODE_PROCESS
	

func _on_resume_pressed():
	get_owner().saveLevel(1)
	get_owner().startGame()

func _on_levels_pressed():
	get_owner().startGame()

func _on_settings_pressed():
	pass
	#buddy.get_node("Label").text = "code: stoecker\ncode: vzhou\nassets: gashley\nlevels: antonio"

func _on_exit_pressed():
	get_tree().quit()

func pause():
	get_tree().paused = true
	$VBoxContainer/Resume.grab_focus()
	visible = true
	
func unpause():
	get_tree().paused = false
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_parent().togglePause()

