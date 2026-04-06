extends Control

@onready var credits_label = $Label

func _ready() -> void:
	# Nastavíme text na začátek (pod obrazovku)
	credits_label.position.y = get_viewport_rect().size.y
	
	# Animace pohybu nahoru
	var tween = create_tween()
	# Titulky vyjedou nahoru během 15 sekund (uprav podle délky textu)
	tween.tween_property(credits_label, "position:y", -credits_label.size.y, 15.0)
	
	# Po skončení titulků se hra vypne nebo skočí do menu
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	get_tree().quit() # Nebo change_scene do Menu
