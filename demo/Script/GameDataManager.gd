extends Node

var level_info = {}
var defualt_level_info = {
	1:{
		"unlocked":true,
		"high_score": 0,
		"stars_unlocked": false
		}
	}
onready var path = "user://save.dat"

func _ready():
	level_info = load_data()

func save_data():
	var file = File.new()
	var err = file.open(path, File.WRITE)
	if err != OK:
		return
	file.store_var(level_info)
	file.close()

func load_data():
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		return defualt_level_info
	var read = {}
	read = file.get_var()
	return read