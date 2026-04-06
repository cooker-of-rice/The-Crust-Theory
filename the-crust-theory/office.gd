extends Node2D

@onready var dialog_text = $DialogUI/Panel/Label
@onready var dialog_panel = $DialogUI/Panel
@onready var ambient_sound = $AmbientSound

func _ready() -> void:
	dialog_panel.hide()
	
	# Základní nastavení Labelu v kódu, aby se nedeformoval
	dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialog_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialog_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Krátká pauza po načtení scény
	await get_tree().create_timer(1.0).timeout
	start_intro_sequence()

func start_intro_sequence():
	# 1. Nuda v kanclu
	show_dialog("DALSÍ NOC, KDY SE NIC NEDEJE. TOHLE MESTO POMALU CHCÍPÁ.")
	await get_tree().create_timer(3.0).timeout
	
	# 2. RÁNA (Vybouření klanu)
	if ambient_sound:
		ambient_sound.play()
	
	# Otřes kamery
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("add_trauma"):
		camera.add_trauma(0.6)
	
	# 3. Reakce na ránu
	show_dialog("CO TO SAKRA BYLO?! SLO TO Z VENKU. MUSÍM TO JÍT PROVERIT.")
	await get_tree().create_timer(3.0).timeout
	
	dialog_panel.hide()

func show_dialog(text: String):
	dialog_panel.show()
	dialog_text.text = text
	
	# --- TADY JE TA OPRAVA ---
	# 1. Resetujeme měřítko, aby písmo nebylo rozmazané (Scale 1,1)
	dialog_text.scale = Vector2(1, 1)
	
	# 2. Vynutíme šířku Labelu (tady byl problém - byl moc úzký)
	# Nastavíme mu šířku podle panelu (např. 400 pixelů nebo šířka panelu)
	dialog_text.custom_minimum_size.x = dialog_panel.size.x - 40
	
	# 3. Nastavíme zalamování a zarovnání
	dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialog_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# 4. Vycentrujeme Label v Panelu (pomocí kotev)
	dialog_text.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	# -----------------------

	# Animace objevení
	dialog_panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(dialog_panel, "modulate:a", 1.0, 0.3)
