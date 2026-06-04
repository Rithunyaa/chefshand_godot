extends Node2D

@onready var card_list = $right_panel/scroll_container/card_list
@onready var trash_can = $trash_can
const CARD_SCENE = preload("res://card.tscn")

var discovered = []
var start_time = 0
var combinations = {
	["egg", "heat"]: "fried_egg",
	["grain", "water", "heat"]: "rice",
	["flour", "water"]: "dough",
	["dough", "heat"]: "bread",
	["bread", "heat"]: "toast",
	["milk", "heat"]: "warm_milk",
	["flour", "egg", "milk"]: "batter",
	["batter", "heat"]: "pancake",
	["tomato", "heat"]: "tomato_sauce",
	["flour", "egg"]: "pasta_dough",
	["pasta_dough", "water", "heat"]: "pasta",
	["pasta", "tomato_sauce"]: "spaghetti",
}

var card_art = {
	"egg": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/eggs_fried.png"),
	"flour": preload("res://assets/images/main_game/flour.png"),
	"salt": preload("res://assets/images/main_game/salt.png"),
	"sugar": preload("res://assets/images/main_game/sugar.png"),
	"oil": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Moonshine.png"),
	"heat": preload("res://assets/images/main_game/fire.png"),
	"water": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/coffee_mocha.png"),
	"milk": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/coffee_milkjug.png"),
	"grain": preload("res://assets/images/main_game/grain.png"),
	"potato": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_potato.png"),
	"onion": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_onion.png"),
	"tomato": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_tomato.png"),
	"lemon": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/fruit_lemon.png"),
	"carrot": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_carrot.png"),
	"garlic": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_garlic.png"),
	"chili": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_jalapeno.png"),
	"chicken": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Chicken.png"),
	"beef": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Steak.png"),
	"shrimp": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Shrimp.png"),
}

var base_ingredients = ["egg", "flour", "salt", "sugar", "oil", "heat", "water", "milk", "grain", "potato", "onion", "tomato", "lemon", "carrot", "garlic", "chili", "chicken", "beef", "shrimp"]

func _ready():
	start_time = Time.get_ticks_msec()
	for ingredient in base_ingredients:
		add_to_panel(ingredient)

func add_to_panel(cname):
	var btn = TextureButton.new()
	btn.custom_minimum_size = Vector2(180, 60)
	var hbox = HBoxContainer.new()
	btn.add_child(hbox)
	var art = TextureRect.new()
	art.texture = card_art[cname]
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.custom_minimum_size = Vector2(40, 40)
	hbox.add_child(art)
	var label = Label.new()
	label.text = cname.capitalize()
	hbox.add_child(label)
	btn.pressed.connect(_on_panel_card_pressed.bind(cname))
	card_list.add_child(btn)

func _on_panel_card_pressed(cname):
	var card = CARD_SCENE.instantiate()
	add_child(card)
	card.setup(cname, card_art[cname])
	card.global_position = get_global_mouse_position()
	card.start_dragging()

func spawn_in_mixing_area(cname, spawn_pos):
	var card = CARD_SCENE.instantiate()
	add_child(card)
	card.global_position = spawn_pos
	card.setup(cname, card_art[cname])

func try_combine(card_a, card_b):
	var names = [card_a.card_name, card_b.card_name]
	names.sort()
	for combo in combinations:
		var sorted_combo = combo.duplicate()
		sorted_combo.sort()
		if sorted_combo == names:
			var result = combinations[combo]
			var spawn_pos = (card_a.global_position + card_b.global_position) / 2
			card_a.queue_free()
			card_b.queue_free()
			spawn_in_mixing_area(result, spawn_pos)
			if result not in discovered:
				discovered.append(result)
				add_to_panel(result)
				_check_win()
			return
	card_a.flash_red()
	card_b.flash_red()

func _check_win():
	if discovered.size() == combinations.size():
		var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
		var minutes = int(elapsed) / 60
		var seconds = int(elapsed) % 60
		print("You win! Time: %d:%02d" % [minutes, seconds])
