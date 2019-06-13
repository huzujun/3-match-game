extends Node

signal create_goal
signal game_won
func _ready():
	create_goals()

func create_goals():
	for i in get_child_count():
		var current = get_child(i)
		emit_signal("create_goal", current.max_needed, current.goal_texture, current.goal_string) 

func check_goal(goal_type):
	for i in get_child_count():
		get_child(i).check_goal(goal_type)
	check_game_win()

func check_game_win():
	if goals_met():
		emit_signal("game_won")

func goals_met():
	for i in get_child_count():
		if !get_child(i).goal_met:
			return false
	return true

func _on_grid_check_goal(goal_type):
	check_goal(goal_type)
	
var current_level
func _on_top_UI_notify_of_level(level):
	current_level = level

func _on_grid_game_win(a):
	GameDataManager.level_info[current_level]["star unlocked"] = true
	GameDataManager.level_info[current_level + 1]={
		"unlocked": true,
		"high_score": 0,
		"stars_unlocked": false
	}
