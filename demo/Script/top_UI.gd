extends TextureRect

onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel
onready var time_label = $MarginContainer/HBoxContainer/TimeLabel
onready var score_bar = $MarginContainer/HBoxContainer/VBoxContainer/TextureProgress
onready var goal_container = $MarginContainer/HBoxContainer/HBoxContainer

export (PackedScene) var goal_prefab
var current_score = 0
var max_score_value = 100
export (int) var current_level
signal notify_of_level
func _ready():
	_on_grid_update_score(current_score)
	setup_score_bar(max_score_value)
	emit_signal("notify_of_level", current_level)

func _on_grid_update_score(amount_to_change):
	current_score += amount_to_change
	update_score_bar()
	score_label.text = String(current_score)

func _on_grid_last_time(last_time):
	time_label.text = String(int(last_time))

func setup_score_bar(max_score):
	score_bar.max_value = max_score

func update_score_bar():
	score_bar.value = current_score

func _on_grid_setup_max_score(max_score):
	 max_score_value = max_score

func make_goal(new_max, new_texture, new_value):
	var current = goal_prefab.instance()
	goal_container.add_child(current)
	current.set_goal_values(new_max, new_texture, new_value)

func _on_GoalHolder_create_goal(new_max, new_texture, new_value):
	make_goal(new_max, new_texture, new_value)


func _on_grid_check_goal(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)