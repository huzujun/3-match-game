extends Node2D

onready var sprite = $Sprite
onready var size_tween = $SizeTween
onready var color_tween = $ColorTween

func setup(new_sprite):
	sprite.texture = new_sprite
	slowly_larger()
	slowly_dimmer()
	
func _ready():
	setup(sprite)
	pass
	
func slowly_larger():
	size_tween.interpolate_property(sprite, "scale", Vector2(1, 1), Vector2(2, 2), 1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	size_tween.start()

func slowly_dimmer():
	color_tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0.2), 1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	color_tween.start()

func _on_SizeTween_tween_completed(object, key):
	slowly_larger()
	
func _on_ColorTween_tween_completed(object, key):
	slowly_dimmer()
