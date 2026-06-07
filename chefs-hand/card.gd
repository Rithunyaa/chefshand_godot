extends Node2D

@onready var card_bg = $card_bg
@onready var ingredient_art = $ingredient_art
@onready var ingredient_name = $ingredient_name
@onready var area = $area

var card_name = ""
var dragging = false
var drag_offset = Vector2()
var original_position = Vector2()

func _ready():
	top_level = true  # 🔥 CRITICAL FIX

func setup(name, art_texture):
	card_name = name
	ingredient_name.text = name
	ingredient_art.texture = art_texture

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
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
		global_position = get_global_mouse_position()

func _is_mouse_over():
	if card_bg.texture == null:
		return false
	var mouse = get_global_mouse_position()
	var size = card_bg.texture.get_size() * card_bg.scale
	var top_left = card_bg.global_position - (size / 2)
	var rect = Rect2(top_left, size)
	return rect.has_point(mouse)

func _check_combination():
	var overlapping = area.get_overlapping_areas()
	if overlapping.is_empty():
		_check_trash()
		return
	for a in overlapping:
		var other_card = a.get_parent()
		if other_card == self:
			continue
		if not other_card.has_method("setup"):
			continue
		get_parent().try_combine(self, other_card)
		return
	_check_trash()

func _check_trash():
	var trash_area = get_parent().get_node("trash_can/Area2D")
	for overlap in area.get_overlapping_areas():
		if overlap == trash_area:
			queue_free()
			return

func flash_red():
	dragging = false
	z_index = 0
	global_position = original_position
	var tween = create_tween()
	tween.tween_property(card_bg, "modulate", Color(1, 0.3, 0.3, 1), 0.1)
	tween.tween_property(card_bg, "modulate", Color(1, 1, 1, 1), 0.1)

func start_dragging():
	dragging = true
	drag_offset = Vector2.ZERO
	original_position = global_position
	global_position = get_viewport().get_mouse_position()
	z_index = 10
