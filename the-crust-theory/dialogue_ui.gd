extends Node2D

@onready var dialog_text = $DialogUI/Panel/Label
@onready var dialog_panel = $DialogUI/Panel
@onready var ambient_sound = $AmbientSound

func _ready() -> void:
	# Na začátku dialog schováme
	dialog_panel.hide()
	
	# Spustíme sekvenci s malým zpožděním
	await get_tree().create_timer(1.0).timeout
	start_intro_sequence()

func start_intro_sequence():
	# 1. První myšlenka Millera
	show_dialog("Miller: Další deštivá noc... a kafe chutná jako vyjetý olej.")
	await get_tree().create_timer(3.0).timeout
	
	# 2. ZVUKOVÝ EFEKT (Vybouření klanu)
	if ambient_sound:
		ambient_sound.play()
	
	# Třes kamery (volitelné, pokud máš na kameře funkci add_trauma)
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("add_trauma"):
		camera.add_trauma(0.5)
	
	show_dialog("*BUM! Ze stok pod ulicí se ozval hrozivý kovový skřípot.*")
	await get_tree().create_timer(3.5).timeout
	
	# 3. Millerova reakce
	show_dialog("Miller: Co to sakra...? Ten zvuk šel od starých stok. Tohle nebude jen potkan.")
	await get_tree().create_timer(3.0).timeout
	
	# 4. Instrukce pro hráče
	show_dialog("Úkol: Prozkoumej vchod do stok v severní části města.")
	await get_tree().create_timer(4.0).timeout
	
	dialog_panel.hide()

func show_dialog(text: String):
	dialog_panel.show()
	dialog_text.text = text
	# Malý efekt: text se neobjeví naráz, ale lehce problikne (noir styl)
	dialog_panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(dialog_panel, "modulate:a", 1.0, 0.3)
