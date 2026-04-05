extends CanvasLayer
# --- ODKAZY NA UZLY ---
@onready var camera: Camera2D = $Camera2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_label: Label = $HUD/HealthLabel # <-- TOTO PŘIDEJ
func update_health_ui() -> void:
	if health_label:
		# Můžeš si text upravit podle chuti
		health_label.text = "ŽIVOTY: " + str(current_health) + " / " + str(max_health)
