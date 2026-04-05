extends Control  # Změněno z CanvasLayer na Control, aby fungovalo 'modulate'

func _ready() -> void:
	# Při startu levelu se schováme
	hide()
	
	# Propojíme tlačítko (ujisti se, že se v editoru jmenuje RetryButton)
	# Pokud ho máš pojmenované jen "Button", změň název níže na $Button
	if has_node("RetryButton"):
		$RetryButton.pressed.connect(_on_retry_pressed)

func show_death_screen() -> void:
	# 1. Zobrazíme uzel
	show()
	
	# 2. Nastavíme počáteční průhlednost na 0 (neviditelný)
	modulate.a = 0
	
	# 3. Vytvoříme plynulé ztmavení (Fade In)
	var tween = create_tween()
	# Toto plynule změní 'modulate.a' na 1.0 během 1 sekundy
	# Funguje to na celý uzel (pozadí, text i tlačítko najednou)
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	
	# 4. Zastavíme zbytek hry (fyziku, nepřátele atd.)
	get_tree().paused = true
	
	# 5. Uvolníme myš, aby mohl detektiv Miller kliknout na tlačítko
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_retry_pressed() -> void:
	# 1. Nejdříve musíme hru odpauzovat, jinak by nová scéna stála
	get_tree().paused = false
	
	# 2. Přepneme zpět do kanceláře
	print("Návrat do kanceláře...")
	get_tree().change_scene_to_file("res://office.tscn")
