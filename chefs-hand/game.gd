extends Node2D

@onready var card_list = $right_panel/scroll_container/card_list
@onready var trash_can = $trash_can
@onready var combo_label = $RichTextLabel
@onready var win_popup = $win_popup
@onready var result_text = $win_popup/VBoxContainer/result_text
const CARD_SCENE = preload("res://card.tscn")
var discovered = []
var start_time = 0

var combinations = {
	["Egg", "Heat"]: "Fried Egg",
	["Egg", "Egg"]: "Scrambled Eggs",
	["Egg", "Water"]: "Soft-boiled Eggs",
	["Flour", "Heat"]: "Bread",
	["Bread", "Salt"]: "Pretzel",
	["Water", "Water"]: "Popsicle",
	["Fish", "Rice"]: "Onigiri",
	["Flour", "Sugar"]: "Cookie",
	["Lemon", "Flour"]: "Tart",
	["Flour", "Milk"]: "Waffles",
	["Chili", "Onion"]: "Soup",
	["Chicken", "Oil"]: "Cooked Chicken",
	["Egg", "Flour"]: "Brownie",
	["Potato", "Heat"]: "Baked Potato",
	["Lemon", "Sugar"]: "Lemon Pie",
	["Rice", "Shrimp"]: "Sushi",
	["Heat", "Milk"]: "Cheesecake",
	["Coffee Bean", "Milk"]: "Coffee",
	["Carrot", "Sugar"]: "Carrot Jam",
	["Heat", "Sugar"]: "Crossaint",
	["Tomato", "Sugar"]: "Tomato Jam",
	}

var card_art = {
	"Egg": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/eggs_brown.png"),
	"Flour": preload("res://assets/images/main_game/flour.png"),
	"Salt": preload("res://assets/images/main_game/salt.png"),
	"Sugar": preload("res://assets/images/main_game/sugar.png"),
	"Oil": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Moonshine.png"),
	"Heat": preload("res://assets/images/main_game/fire.png"),
	"Water": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/coffee_mocha.png"),
	"Milk": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/coffee_milkjug.png"),
	"Rice": preload("res://assets/images/main_game/grain.png"),
	"Potato": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/PotatoRed.png"),
	"Onion": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_onion.png"),
	"Tomato": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_tomato.png"),
	"Lemon": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/fruit_lemon.png"),
	"Carrot": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_carrot.png"),
	"Garlic": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_garlic.png"),
	"Chili": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/vegetable_jalapeno.png"),
	"Chicken": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/FishSteak.png"),
	"Shrimp": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Shrimp.png"),
	"Fried Egg": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/eggs_fried.png"),
	"Scrambled Eggs": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/eggs_scrambled.png"),
	"Soft-boiled Eggs": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/eggs_softboiled.png"),
	"Bread": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/pastry_baguette.png"),
	"Pretzel": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/pastry_pretzel.png"),
	"Popsicle": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/popsicle_blue.png"),
	"Fish": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/FishFillet.png"),
	"Onigiri": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/onigiri_4.png"),
	"Cookie": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Cookie.png"),
	"Tart": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Tart.png"),
	"Waffles": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Waffles.png"),
	"Soup": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/canned_soup.png"),
	"Cooked Chicken": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Jerky.png"),
	"Brownie": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Brownie.png"),
	"Baked Potato": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Potato.png"),
	"Lemon Pie": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/PieLemon.png"),
	"Sushi": preload("res://assets/images/main_game/FreePixelFood/FreePixelFood/Assets/FreePixelFood/Sprite/Food/Sushi.png"),
	"Cheesecake": preload("C:/Users/Rithunyaa/chefshand_godot/chefs-hand/assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/cake_cheese.png"),
	"Coffee": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/coffee_espresso.png"),
	"Carrot Jam": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/jam_peach.png"),
	"Crossaint": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/pastry_croissant.png"),
	"Tomato Jam": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/jam_strawberry.png"),
	"Coffee Bean": preload("res://assets/images/main_game/Free_pixel_food_16x16/Free_pixel_food_16x16/Icons/coffee_darkroast.png"),
	}

var base_ingredients = [
	"Egg","Flour","Salt","Sugar","Oil","Heat","Water","Milk",
	"Onion","Tomato","Lemon","Carrot", "Chili","Chicken",
	"Shrimp", "Fish", "Rice", "Potato", "Coffee Bean"]

func _ready():
	start_time = Time.get_ticks_msec()
	for ingredient in base_ingredients:
		add_to_panel(ingredient)
	update_combo_label()
	print("Loaded ingredients:", card_list.get_child_count())

func add_to_panel(cname):
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(180, 60)
	var hbox = HBoxContainer.new()
	btn.add_child(hbox)
	var art = TextureRect.new()
	if card_art.has(cname):
		art.texture = card_art[cname]
	art.custom_minimum_size = Vector2(40, 40)
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hbox.add_child(art)
	var label = Label.new()
	label.text = cname.capitalize()
	hbox.add_child(label)
	btn.pressed.connect(_on_panel_card_pressed.bind(cname))
	card_list.add_child(btn)

func _on_panel_card_pressed(cname):
	var card = CARD_SCENE.instantiate()
	get_tree().current_scene.add_child(card)
	var art = card_art.get(cname, null)
	card.setup(cname, art)
	card.global_position = get_viewport().get_mouse_position()
	card.start_dragging()

func spawn_in_mixing_area(cname, spawn_pos):
	var card = CARD_SCENE.instantiate()
	get_tree().current_scene.add_child(card)
	var art = card_art.get(cname, null)
	card.setup(cname, art)
	card.global_position = spawn_pos

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
				update_combo_label()
				_check_win()
			return
	card_a.flash_red()
	card_b.flash_red()
	return false

func _check_win():
	if discovered.size() >= combinations.size():
		var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
		var minutes = int(elapsed) / 60
		var seconds = int(elapsed) % 60
		result_text.text = ("[center]You found all the combinations!\n\n"+ "Time: %d:%02d[/center]"% [minutes, seconds])
		win_popup.visible = true
		get_tree().paused = true

func update_combo_label():
	combo_label.text = str(discovered.size()) + "/" + str(combinations.size()) + " combinations found"
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			var elapsed = 245 # fake time in seconds
			var minutes = int(elapsed) / 60
			var seconds = int(elapsed) % 60
			result_text.text = (
				"You found all combinations!\n\n"
				+ "Time: %d:%02d" % [minutes, seconds]
			)
			win_popup.visible = true
			get_tree().paused = false

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://homescreen.tscn")
	get_tree().paused = false


func _on_replay_button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
