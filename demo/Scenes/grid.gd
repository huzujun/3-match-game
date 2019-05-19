extends Node2D

#Grid Variables
export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var offset;

var all_pieces = [];
var possible_pieces = [
	preload("res://Scenes/Pieces/Croissant.tscn"),
	preload("res://Scenes/Pieces/Cupcake.tscn"),
	preload("res://Scenes/Pieces/Danish.tscn"),
	preload("res://Scenes/Pieces/Donut.tscn"),
	preload("res://Scenes/Pieces/Macaroon.tscn"),
	preload("res://Scenes/Pieces/SugarCookie.tscn"),
];
# Called when the node enters the scene tree for the first time.
func _ready():
	all_pieces = make_2d_array();
	spawn_pieces();
	print(all_pieces);
	
func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func spawn_pieces():
	for i in width:
		for j in height:
			var rand = floor(rand_range(0, possible_pieces.size()));
			var piece = possible_pieces[rand].instance();
			add_child(piece);
			piece.position = grid_to_pixel(i, j);

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column;
	var new_y = y_start - offset * row;
	return Vector2(new_x, new_y); 
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
