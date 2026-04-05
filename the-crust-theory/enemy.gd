extends CharacterBody2D

# --- NASTAVENÍ (Můžeš měnit v Inspektoru) ---
var knockback_velocity: Vector2 = Vector2.ZERO
var pause_timer: float = 0.0
@export var speed: float = 80.0             # Rychlost sunutí
@export var detection_range: float = 350.0  # Zvětšený dosah viditelnosti
@export var attack_range: float = 60.0     # Dosah pro zahájení útoku
@export var max_health: int = 3
var current_health: int
var can_attack: bool = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: int = 1
var player: Node2D = null

func _ready() -> void:
	current_health = max_health
	# Hledáme hráče ve skupině "Player"
	player = get_tree().get_first_node_in_group("Player")
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Gravitace
	if not is_on_floor():
		velocity.y += 980 * delta
	
	if player and is_instance_valid(player):
		var dist = global_position.distance_to(player.global_position)
		
		# 1. PRIORITA: ÚTOK (Pokud je dost blízko)
		if dist <= attack_range:
			velocity.x = 0 # Při útoku se nepohybuje
			if can_attack:
				perform_melee_attack()
		
		# 2. POHYBU: PRONÁSLEDOVÁNÍ (Pokud tě vidí, ale jsi dál)
		elif dist < detection_range:
			direction = 1 if player.global_position.x > global_position.x else -1
			velocity.x = direction * speed
			if can_attack: # Hraje idle i při sunutí, jak jsme chtěli
				sprite.play("idle")
		
		# 3. KLID: HRÁČ JE MOC DALEKO
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			sprite.play("idle")
	
	
	# Otáčení spritu
	if velocity.x != 0:
		sprite.flip_h = (direction == -1)
	
	move_and_slide()

func perform_melee_attack() -> void:
	can_attack = false
	
	# 1. ŠVIH (Rychlý start animace)
	sprite.play("attack")
	
	# Časování: Za jak dlouho od začátku animace má hráč dostat damage?
	# Zkus 0.1 nebo 0.2 pro pocit bleskového útoku.
	await get_tree().create_timer(0.15).timeout 
	
	# 2. KONTROLA ZÁSAHU (Hned po švihu)
	if is_instance_valid(player):
		var final_dist = global_position.distance_to(player.global_position)
		if final_dist <= attack_range + 25: 
			player.take_damage(1)
			print("RYCHLÝ ZÁSAH!")

	# 3. DOJEZD (Jak dlouho zůstane v útočné póze po ráně)
	# Zkráceno na minimum, aby to nevypadalo jako "motyka"
	await get_tree().create_timer(0.2).timeout
	
	if is_instance_valid(self):
		sprite.play("idle")
	
	# 4. COOLDOWN (Pauza mezi útoky, aby Miller mohl utéct nebo ho zabít)
	# Pokud chceš, aby útočili zběsile, dej sem 0.5. Pokud mají být pomalejší, nech 1.2.
	await get_tree().create_timer(1.2).timeout
	can_attack = true

func take_damage(amount: int) -> void:
	current_health -= amount
	
	# --- KNOCKBACK (Odhození) ---
	# Určíme směr od hráče (pokud je hráč vlevo, letí nepřítel doprava)
	var knockback_dir = 1 if player.global_position.x < global_position.x else -1
	velocity.x = knockback_dir * 450.0 # Síla rány (uprav podle libosti)
	velocity.y = -150.0 # Malé nadskočení, aby "odletěl" od země
	
	# --- STUN (Krátké omráčení) ---
	can_attack = false
	var tween = create_tween()
	sprite.modulate = Color(2, 2, 2) # Bílé probliknutí (vypadá to víc noir/akčně)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	# Po krátké pauze se může zase hýbat/útočit
	await get_tree().create_timer(0.3).timeout
	can_attack = true
	
	if current_health <= 0:
		die()

func die() -> void:
	# Tady můžeš přidat efekt prachu nebo zvuk
	queue_free()
