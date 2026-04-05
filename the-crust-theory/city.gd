extends Node2D # Nebo cokoliv, co je tvůj hlavní uzel levelu

@onready var camera: Camera2D = $Camera2D # Odkaz na tvou kameru
@onready var player: Node2D = $Player   # Odkaz na tvého hráče

func _ready() -> void:
	# Spustíme filmový úvod
	start_camera_intro()

func start_camera_intro() -> void:
	# 1. Zjistíme finální pozici (kde stojí hráč)
	var final_pos = player.global_position
	
	# 2. Nastavíme startovní pozici kamery (daleko vpravo)
	# Přidáme k X souřadnici hráče třeba 800 pixelů
	var start_pos = final_pos + Vector2(800, 0)
	camera.global_position = start_pos
	
	# 3. Odpojíme kameru od hráče (pokud je uvnitř jeho uzlu)
	# To je klíčové, aby Tween mohl kamerou hýbat nezávisle na pohybu hráče
	var original_parent = camera.get_parent()
	if original_parent == player:
		# Dočasně ji přesuneme do hlavního levelu
		camera.reparent(get_tree().current_scene)
	
	# 4. Vytvoříme Tween pro plynulý pohyb ("připlutí")
	var tween = create_tween()
	
	# Nastavíme typ pohybu (EASING) pro filmový efekt:
	# TRANS_CUBIC = plynulý rozjezd i dojezd
	# EASE_OUT = zpomalení na konci (nejlepší pro přílet)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# 5. Spustíme pohyb:
	# Změň 'global_position' na 'final_pos' během 2.5 vteřiny
	tween.tween_property(camera, "global_position", final_pos, 2.5)
	
	# 6. Co se stane, když Tween skončí:
	# Připojíme kameru zpět k hráči, aby ho sledovala při chůzi
	if original_parent == player:
		# Použijeme lambda funkci, která se zavolá po skončení Tweenu
		tween.finished.connect(func():
			camera.reparent(player)
			# Vyresetujeme lokální pozici, aby byla vycentrovaná na hráči
			camera.position = Vector2.ZERO 
			print("Kamera ustálena na Millerovi!")
