extends Node2D

#Level Stuff
export (int) var level
export (String) var level_to_load
export (bool) var enabled
export (bool) var score_goal_met
#Texture Stuff
export (Texture) var blocked_texture
export (Texture) var open_texture
export (Texture) var goal_met
export (Texture) var goal_not_met

onready var level_label = $TextureButton/Label
onready var button = $TextureButton
onready var star = $Sprite
func _ready():
	if GameDataManager.level_info.has(level):
		score_goal_met = GameDataManager.level_info[level]["stars_unlocked"]
		enabled = GameDataManager.level_info[level]["unlocked"]
	else:
		score_goal_met = false
		enabled = false
	setup()

func _process(delta):
	if GameDataManager.level_info.has(level):
		score_goal_met = GameDataManager.level_info[level]["stars_unlocked"]
		enabled = GameDataManager.level_info[level]["unlocked"]
	else:
		score_goal_met = false
		enabled = false
	setup()

func setup():
	level_label.text = String(level)
	if enabled:
		button.texture_normal = open_texture
	else:
		button.texture_normal = blocked_texture
	if score_goal_met:
		star.texture = goal_met
	else:
		star.texture = goal_not_met
	

func _on_TextureButton_pressed():
	if enabled:
		get_tree().change_scene(level_to_load)
	