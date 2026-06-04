extends Control

@onready var play_button = $playbutton
@onready var settings_button = $settingsbutton
@onready var settings_popup = $settings_popup
@onready var music_button = $music_button
@onready var sfx_button = $sfx_toggle
@onready var music_label = $musiclabel
@onready var sfx_label = $sfxlabel
@onready var fade_out = $fade_out
@onready var music_player = $music_player
@onready var sfx_player = $sfx_player

var play_original_scale

func _ready():
	fade_out.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_out.visible = true
	fade_out.modulate.a = 0
	_set_popup_visible(false)
	music_button.text = "ON" if Global.music_enabled else "OFF"
	sfx_button.text = "ON" if Global.sfx_enabled else "OFF"
	if !Global.music_enabled:
		music_player.stop()
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	music_button.pressed.connect(_on_music_pressed)
	sfx_button.pressed.connect(_on_sfx_pressed)
	play_original_scale = play_button.scale
	play_button.mouse_entered.connect(_on_play_hover)
	play_button.mouse_exited.connect(_on_play_exit)
	play_button.button_down.connect(_on_play_hover)
	play_button.button_up.connect(_on_play_exit)

func _set_popup_visible(state):
	settings_popup.visible = state
	music_button.visible = state
	sfx_button.visible = state
	music_label.visible = state
	sfx_label.visible = state

func _play_sfx():
	if Global.sfx_enabled:
		sfx_player.play()

func _on_play_pressed():
	_play_sfx()
	fade_out.visible = true
	fade_out.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(fade_out, "modulate:a", 1.0, 1.5)
	await tween.finished
	get_tree().change_scene_to_file("res://game.tscn")

func _on_settings_pressed():
	_play_sfx()
	_set_popup_visible(!settings_popup.visible)

func _on_music_pressed():
	_play_sfx()
	Global.music_enabled = !Global.music_enabled
	if Global.music_enabled:
		music_button.text = "ON"
		music_player.play()
	else:
		music_button.text = "OFF"
		music_player.stop()

func _on_sfx_pressed():
	Global.sfx_enabled = !Global.sfx_enabled
	if Global.sfx_enabled:
		sfx_button.text = "ON"
		sfx_player.play()
	else:
		sfx_button.text = "OFF"

func _unhandled_input(event):
	if !settings_popup.visible:
		return
	if event is InputEventMouseButton and event.pressed:
		if music_button.get_global_rect().has_point(event.position):
			return
		if sfx_button.get_global_rect().has_point(event.position):
			return
		if settings_button.get_global_rect().has_point(event.position):
			_set_popup_visible(false)
			return
		_set_popup_visible(false)

func _on_play_hover():
	var tween = create_tween()
	tween.tween_property(play_button, "scale", play_original_scale * 1.03, 0.08)

func _on_play_exit():
	var tween = create_tween()
	tween.tween_property(play_button, "scale", play_original_scale, 0.08)
