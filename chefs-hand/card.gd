extends Node2D

@onready var card_bg = $card_bg
@onready var ingredient_art = $ingredient_art
@onready var ingredient_name = $ingredient_name
@onready var area = $area

var card_name = ""
var dragging = false
var drag_offset = Vector2()
var original_position = Vector2()

func setup(name, art_texture):
	card_name = name
	ingredient_name.text = name
	ingredient_art.texture = art_texture

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not dragging:
				if _is_mouse_over():
					dragging = true
					drag_offset = global_position - get_global_mouse_position()
					original_position = global_position
					z_index = 10
					get_viewport().set_input_as_handled()
			else:
				if dragging:
					dragging = false
					z_index = 0
					_check_combination()
					get_viewport().set_input_as_handled()
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + drag_offset

func _is_mouse_over():
	var mouse = get_global_mouse_position()
	var card_size = card_bg.texture.get_size() * card_bg.scale
	var rect = Rect2(global_position - card_size / 2, card_size)
	return rect.has_point(mouse)

func _check_combination():
	var overlapping = area.get_overlapping_areas()
	if overlapping.size() > 0:
		var other_card = overlapping[0].get_parent()
		if other_card != self and other_card.has_method("setup"):
			get_parent().try_combine(self, other_card)
	else:
		_check_trash()

func _check_trash():
	var trash = get_parent().get_node("trash_can")
	var mouse = get_global_mouse_position()
	var trash_rect = Rect2(trash.global_position - Vector2(40, 40), Vector2(80, 80))
	if trash_rect.has_point(mouse):
		queue_free()

func flash_red():
	var tween = create_tween()
	tween.tween_property(card_bg, "modulate", Color(1, 0.3, 0.3, 1), 0.1)
	tween.tween_property(card_bg, "modulate", Color(1, 1, 1, 1), 0.1)
	global_position = original_position

func start_dragging():
	dragging = true
	drag_offset = Vector2.ZERO
	original_position = global_position
	z_index = 10
