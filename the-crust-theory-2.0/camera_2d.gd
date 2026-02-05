extends Camera2D

# --- KONFIGURACE ---
@export var decay: float = 0.8  # Jak rychle otřes mizí (0 = nikdy, 1 = okamžitě)
@export var max_offset: Vector2 = Vector2(10, 10) # Maximální posun v pixelech při plném otřesu
@export var max_roll: float = 0.1 # Maximální rotace (radiány)

# --- STAV ---
var trauma: float = 0.0 # Aktuální úroveň otřesu (0.0 až 1.0)
var trauma_power: int = 2 # Síla otřesu (square funkce pro lepší feel)

func _ready() -> void:
	# Zapneme smoothing, pokud není nastaven v editoru
	position_smoothing_enabled = true
	position_smoothing_speed = 5.0 # Nižší hodnota = "těžší", filmovější kamera

func _process(delta: float) -> void:
	if trauma > 0:
		# Snížení traumatu v čase
		trauma = max(trauma - decay * delta, 0)
		shake()

# Funkce, kterou zavoláš z jiných skriptů (např. při výstřelu: camera.add_trauma(0.3))
func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func shake() -> void:
	# Výpočet síly otřesu (nelineární, vypadá lépe)
	var amount = pow(trauma, trauma_power)
	
	# Aplikace náhodného posunu pomocí noise nebo simple rand
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
