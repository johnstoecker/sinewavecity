extends Node2D

var data = {}

var isPaused = false
var inGame = false

func _ready():
	$GameScene.hide()
	data = getDataFromCookies()
	print("data: %s" % data)
	
func saveDataToCookies():
	var save_game = File.new()
	save_game.open("user://game", File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()

func getDataFromCookies():
	var save_game = File.new()
	if not save_game.file_exists("user://user"):
		return {}
	
	save_game.open("user://game", File.READ)
	var result = parse_json(save_game.get_line())
	save_game.close()
	
	return result

func starLevel(level):
	print("starting game....")
	inGame = true
	$MainMenu.visible = false
	$LevelsMenu.visible = false
#	get_tree().change_scene("res://GameScene.tscn")
	$GameScene.show()
	$GameScene.start_level(level)

func showMainMenu():
	$GameScene.stop()
	$Opacity.visible = false
	$PauseMenu.visible = false
	inGame = false
	$GameScene.visible = false
	$MainMenu.visible = true
	$MainMenu/Control/VBoxContainer/NewGame.grab_focus()

func showLevelsMenu():
	print("showing levels menu")
	$GameScene.stop()
	$Opacity.visible = false
	$MainMenu.visible = false
	inGame = false
	$GameScene.visible = false
	$LevelsMenu.visible = true
	$LevelsMenu/Control/VBoxContainer/Level1.grab_focus()

func saveLevel(value):
	data["current_level"] = value
	print("saved value %s to key %s" % [value, "current_level"])
	
func getLevel():
	print("got value %s for key %s" % [data.get("current_level", 1), "current_level"])
	# default to level 1
	return data.get("current_level", 1)

func pause():
	$Opacity.visible = true
	$PauseMenu.pause()
	$GameScene.pause()
	
func unpause():
	$Opacity.visible = false
	$GameScene.unpause()
	$PauseMenu.unpause()

func escapePressed():
	if inGame:
		if isPaused:
			unpause()
		else:
			pause()
		isPaused = !isPaused
	else:
		get_tree().quit()
		

func hit():
	$GameScene.hit()
