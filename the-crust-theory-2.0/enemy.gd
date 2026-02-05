class_name Enemy
extends CharacterBody2D

# --- NASTAVENÍ ---
@export var speed: float = 60.0
@export var gravity: float = 980.0
@export var detection_range: float = 150.0 # Jak daleko vidí (v pixelech)

var direction: int = 1
var player: Node2D = null # Odkaz na hráče

@onready var ledge_check: RayCast2D = $LedgeCheck
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Najdeme hráče automaticky podle skupiny "Player"
	# (Musíme ale hráče do té skupiny přidat - viz návod níže!)
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	# 1. Gravitace
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# 2. Rozhodování AI (Mozek)
	if player and can_see_player():
		# --- STAV: VIDÍM HRÁČE ---
		# Zastav se
		velocity.x = 0
		# Otoč se čelem k hráči
		look_at_player()
	else:
		# --- STAV: PATROLOVÁNÍ ---
		patrol_logic()
	
	# 3. Aplikace pohybu
	move_and_slide()

# --- POMOCNÉ FUNKCE ---

func can_see_player() -> bool:
	# Změříme vzdálenost mezi nepřítelem a hráčem
	var distance = global_position.distance_to(player.global_position)
	# Pokud je blízko A zrovna neumřel
	return distance < detection_range

func look_at_player() -> void:
	# Pokud je hráč vpravo, direction = 1, jinak -1
	if player.global_position.x > global_position.x:
		direction = 1
	else:
		direction = -1
	update_visuals()

func patrol_logic() -> void:
	# Otočení na kraji propasti nebo u zdi
	if is_on_wall() or (is_on_floor() and not ledge_check.is_colliding()):
		direction *= -1
		# Posuneme RayCast na druhou stranu
		ledge_check.position.x = abs(ledge_check.position.x) * direction
	
	velocity.x = direction * speed
	update_visuals()

func update_visuals() -> void:
	# Otočení spritu podle směru
	sprite.flip_h = (direction == -1)
