extends Node2D

var data = {}

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

func startGame():
	$MainMenu.queue_free()
	get_tree().change_scene("res://GameScene.tscn")
	$GameScene.show()
	$GameScene.start_game()


func saveLevel(value):
	data["current_level"] = value
	print("saved value %s to key %s" % [value, "current_level"])
	
func getLevel():
	print("got value %s for key %s" % [data.get("current_level", 1), "current_level"])
	# default to level 1
	return data.get("current_level", 1)
