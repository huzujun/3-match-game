extends Node2D

#Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
export (int) var y_offset
signal setup_max_score
export (int) var max_score
enum {wait, move}
var state
var all_pieces = []

var top_ui
var partical_effect = preload("res://Scenes/DestroyPartical.tscn")
var piece_one = null
var piece_two = null
var last_place = Vector2(0, 0)
var last_direction = Vector2(0, 0)
var move_checked = false
var first_touch = Vector2(0, 0)
var final_touch = Vector2(0, 0)

var goal_met = false
signal check_goal
var possible_pieces = [
	preload("res://Scenes/Pieces/Croissant.tscn"),
	preload("res://Scenes/Pieces/Cupcake.tscn"),
	preload("res://Scenes/Pieces/Danish.tscn"),
	preload("res://Scenes/Pieces/Donut.tscn"),
	preload("res://Scenes/Pieces/Macaroon.tscn"),
	preload("res://Scenes/Pieces/SugarCookie.tscn"),
]

var hint_effect = preload("res://Scenes/HintEffect.tscn")
signal update_score
signal last_time
signal game_over
export (int) var piece_value
var streak = 1
var game_timer
var is_moves
# Called when the node enters the scene tree for the first time.
func _ready():
	state = move
	first_touch = null
	final_touch = null
	all_pieces = make_2d_array()
	randomize()
	spawn_pieces()
	game_timer = get_parent().get_node("game_timer")
	game_timer.set_wait_time(30)
	is_moves = 0
	game_timer.start()
	game_timer.set_paused(true)
	emit_signal("game_over", false)
	emit_signal("setup_max_score", max_score)
	top_ui = get_parent().get_node("top_UI")
	
func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func spawn_pieces():
	for i in width:
		for j in height:
			var rand = floor(rand_range(0, possible_pieces.size()))
			var loops = 0
			var piece = possible_pieces[rand].instance()
			while (match_at(i, j, piece.color) && loops < 100):
				rand = floor(rand_range(0, possible_pieces.size()))
				loops += 1
				piece = possible_pieces[rand].instance()
			add_child(piece)
			piece.position = grid_to_pixel(i, j)
			all_pieces[i][j] = piece
	if is_deadlocked():
		shuffle_board()

func switch_pieces(place, direction, array):
	var tmp = array[place.x + direction.x][place.y + direction.y]
	array[place.x + direction.x][place.y + direction.y] = array[place.x][place.y]
	array[place.x][place.y] = tmp

func switch_and_check(place, direction, array):
	switch_pieces(place, direction, array)
	if find_matches(true, array):
		switch_pieces(place, direction, array)
		return true
	switch_pieces(place, direction, array)
	return false

func is_deadlocked():
	for i in width - 1:
		for j in height - 1:
			if switch_and_check(Vector2(i, j), Vector2(1, 0), all_pieces):
				return false
			if switch_and_check(Vector2(i, j), Vector2(0, 1), all_pieces):
				return false
	return true

func clear_and_store_board():
	var holder_array = []
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				holder_array.append(all_pieces[i][j])
				all_pieces[i][j] = null
	return holder_array

func shuffle_board():
	var holder_array = clear_and_store_board()
	for i in width:
		for j in height:
			var rand = floor(rand_range(0, holder_array.size()))
			var loops = 0
			var piece = holder_array[rand]
			while (match_at(i, j, piece.color) && loops < 100):
				rand = floor(rand_range(0, holder_array.size()))
				loops += 1
				piece = holder_array[rand]
			
			piece.move(grid_to_pixel(i, j))
			all_pieces[i][j] = piece
			holder_array.remove(rand)
	if is_deadlocked():
		shuffle_board()
	state = move

func match_at(i, j, color):
	if i > 1:
		if all_pieces[i - 1][j] != null && all_pieces[i - 2][j] != null:
			if all_pieces[i - 1][j].color == color && all_pieces[i - 2][j].color == color:
				return true
	if j > 1:
		if all_pieces[i][j - 1] != null && all_pieces[i][j - 2] != null:
			if all_pieces[i][j - 1].color == color && all_pieces[i][j - 2].color == color:
				return true
	return false

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start - offset * row
	return Vector2(new_x, new_y) 
	pass

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y) 
	pass

func is_in_grid(grid_position):
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true
	return false

var controlling = false
func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)):
			first_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)
			controlling = true
			if hint != null and is_instance_valid(hint):
				hint.queue_free()
	if Input.is_action_just_released("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)):
			controlling = false
			final_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)
			touch_difference(first_touch, final_touch)
			
func swap_pieces(column, row, direction):
	var first_piece = all_pieces[column][row]
	var other_piece = all_pieces[column + direction.x][row + direction.y]
	if first_piece != null && other_piece != null:
		store_info(first_piece, other_piece, Vector2(column, row), direction)
		all_pieces[column][row] = other_piece
		all_pieces[column + direction.x][row + direction.y] = first_piece
		first_piece.move(grid_to_pixel(column + direction.x, row + direction.y))
		other_piece.move(grid_to_pixel(column, row))
		if !move_checked:
			find_matches()

func touch_difference(grid_1, grid_2):
	if grid_1 == null or grid_2 == null:
		return
	var difference = grid_2 - grid_1
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(1, 0))
		elif difference.x < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(-1, 0))
	elif abs(difference.x) < abs(difference.y):
		if difference.y > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, 1))
		elif difference.y < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, -1))

func find_matches(query = false, array = all_pieces):
	for i in width:
		for j in height:
			if array[i][j] != null and is_instance_valid(array[i][j]): 
				var current_color = array[i][j].color
				if i > 0 && i < width - 1 && array[i - 1][j] != null && all_pieces[i + 1][j] != null:
					if is_instance_valid(array[i - 1][j]) and is_instance_valid(array[i][j]) and is_instance_valid(array[i + 1][j]):
						if array[i - 1][j].color == current_color && all_pieces[i + 1][j].color == current_color:
							if query:
								return true
							dim(i - 1, j)
							dim(i, j)
							dim(i + 1, j)
				if j > 0 && j < height - 1 && array[i][j - 1] != null && all_pieces[i][j + 1] != null:
					if is_instance_valid(array[i][j - 1]) and is_instance_valid(array[i][j]) and is_instance_valid(array[i][j + 1]):
						if array[i][j - 1].color == current_color && all_pieces[i][j + 1].color == current_color:
							if query:
								return true
							dim(i, j - 1)
							dim(i, j)
							dim(i, j + 1)
	if query:
		return false
	get_parent().get_node("destroy_timer").start()

func dim(i, j):
	all_pieces[i][j].matched = true
	all_pieces[i][j].dim()

func destroy_matched():
	var was_matched = false
	for i in width:
		for j in height:
			if all_pieces[i][j] != null and is_instance_valid(all_pieces[i][j]):
				if all_pieces[i][j].matched:
					emit_signal("check_goal", all_pieces[i][j].color)
					was_matched = true
					all_pieces[i][j].queue_free()
					all_pieces[i][j] = null
					make_effect(partical_effect, i, j)
					emit_signal("update_score", piece_value * streak)
	move_checked = true
	if is_moves == 0:
		is_moves = 1
		state = move
	
	if was_matched:
		get_parent().get_node("collapse_timer").start()
	else:
		swap_back()
	
func make_effect(effect, column, row):
	var current = effect.instance()
	current.position = grid_to_pixel(column, row)
	add_child(current)

func store_info(first_piece, other_piece, place, direction):
	piece_one = first_piece
	piece_two = other_piece
	last_place = place
	last_direction = direction

func swap_back():
	if piece_one!=null && piece_two != null:
		swap_pieces(last_place.x, last_place.y, last_direction)
	move_checked = false
	
func collapse_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				for k in range(j + 1, height):
					if all_pieces[i][k] != null and is_instance_valid(all_pieces[i][k]):
						all_pieces[i][k].move_down(grid_to_pixel(i,j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	get_parent().get_node("refill_timer").start()

func refill_columns():
	streak += 1
	for i in width:
		for j in height:
			if all_pieces[i][j] == null:
				var rand = floor(rand_range(0, possible_pieces.size()))
				var loops = 0
				var piece = possible_pieces[rand].instance()
				while (match_at(i, j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()))
					loops += 1
					piece = possible_pieces[rand].instance()
				add_child(piece)
				piece.position = grid_to_pixel(i, j - y_offset)
				piece.move(grid_to_pixel(i, j))
				all_pieces[i][j] = piece
	after_refill()

func find_all_matched():
	var hint_holder = []
	for i in width - 1:
		for j in height - 1:
			if all_pieces[i][j] != null:
				if switch_and_check(Vector2(i, j), Vector2(1, 0), all_pieces):
					hint_holder.append(all_pieces[i][j])
				if switch_and_check(Vector2(i, j), Vector2(0, 1), all_pieces):
					hint_holder.append(all_pieces[i][j])
	return hint_holder
	
var hint
func generate_hint():
	if hint != null and is_instance_valid(hint):
		hint.queue_free()
	var hints = find_all_matched()
	if hints != null:
		hint = hint_effect.instance()
		add_child(hint)
		hint.position = hints[0].position
		hint.setup(hints[0].get_node("Sprite").texture)
		
func after_refill():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if match_at(i, j, all_pieces[i][j].color):
					find_matches()
					get_parent().get_node("destroy_timer").start()
					break
	streak = 1
	move_checked = false

func _on_destroy_timer_timeout():
	destroy_matched()

func _process(delta):
	if state == move:
		touch_input()
	emit_signal("last_time", game_timer.get_time_left())
	
	if is_moves == 1:
		is_moves = -1
		game_timer.set_paused(false)

func _on_collapse_timer_timeout():
	collapse_columns()

func _on_refill_timer_timeout():
	refill_columns()
	if is_deadlocked():
		shuffle_board()
	
func declare_gameover():
	emit_signal("game_over")
	state = wait

func _on_game_timer_timeout():
	declare_gameover()
	game_timer.stop()

func _on_GoalHolder_game_won():
	goal_met = true
	game_timer.stop()

func _on_button_ui_hint():
	if top_ui.current_score > 10:
		generate_hint()
		emit_signal("update_score", -10)

func _on_button_ui_plus():
	if top_ui.current_score > 50:
		var left_time = game_timer.get_time_left()+10
		game_timer.stop()
		game_timer.set_wait_time(left_time)
		game_timer.start()
		emit_signal("update_score", -50)
	