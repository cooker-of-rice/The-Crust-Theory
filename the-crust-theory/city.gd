extends Node2D

@onready var dialog_text = $DialogUI/Panel/Label
@onready var dialog_panel = $DialogUI/Panel
@onready var ambient_sound = $AmbientSound

var level_cleared: bool = false

func _process(_delta: float) -> void:
	# Kontrolujeme, zda už jsme sekvenci nespustili a zda jsou všichni mrtví
	if not level_cleared:
		var enemies = get_tree().get_nodes_in_group("Enemies")
		if enemies.size() == 0:
			level_cleared = true
			start_outro_sequence()

func start_outro_sequence():
	# Malá pauza po zabití posledního, aby to nebylo hned
	await get_tree().create_timer(1.5).timeout
	
	# 1. RÁNA
	if ambient_sound:
		ambient_sound.play()
	
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("add_trauma"):
		camera.add_trauma(0.8) # Silnější rána než v kanclu
	
	# 2. DIALOG
	show_dialog("TA RÁNA... PRISLO TO PRIMO ODSUD, Z KANÁLU.")
	await get_tree().create_timer(3.0).timeout
	
	show_dialog("NENÍ CESTY ZPET. MUSÍM TAM VLÉZT A UKONCIT TO.")
	await get_tree().create_timer(3.5).timeout
	
	dialog_panel.hide()
	
	# 3. PŘECHOD DO DALŠÍHO LEVELU
	# Tady změníš scénu na tu se stokami/bossem
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://sewer_level.tscn")

func show_dialog(text: String):
	dialog_panel.show()
	dialog_text.text = text
	
	# Resetujeme měřítko a vycentrujeme (Fix z minula)
	dialog_text.scale = Vector2(1, 1)
	dialog_text.custom_minimum_size.x = dialog_panel.size.x - 40
	
	dialog_panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(dialog_panel, "modulate:a", 1.0, 0.3)
