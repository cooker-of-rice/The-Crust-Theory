extends CharacterBody2D

# --- KONFIGURACE ---
@export var speed: float = 50.0
@export var gravity: float = 980.0
@export var max_health: int = 15
var current_health: int
var has_hit_player_this_charge: bool = false
var last_attack_was_charge: bool = false # NOVÉ: Sleduje poslední útok

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var slam_player: AudioStreamPlayer = $SlamPlayer
@onready var attack_area: Area2D = $AttackArea 
@onready var attack_particles: GPUParticles2D = get_node_or_null("AttackParticles")

@export var slam_sound: AudioStream

# --- STAVY ---
enum State { IDLE, CHARGE, SMASH, DEAD }
var current_state: State = State.IDLE
var player: Node2D = null
var direction: int = 1
var charge_dir: int = 1

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("Player")
	
	var music = get_tree().current_scene.get_node_or_null("BossMusic")
	if music:
		music.play()
	
	start_boss_loop()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	match current_state:
		State.IDLE:
			velocity.x = move_toward(velocity.x, 0, speed)
			if player: look_at_player()
			sprite.play("idle")
		
		State.CHARGE:
			velocity.x = charge_dir * (speed * 6.0)
			
			if not has_hit_player_this_charge:
				for i in get_slide_collision_count():
					var collision = get_slide_collision(i)
					var target = collision.get_collider()
					
					if target and target.is_in_group("Player"):
						target.take_damage(1)
						has_hit_player_this_charge = true 
						print("RUSH HIT!")
			
			if is_on_wall():
				current_state = State.IDLE
	
	move_and_slide()

func start_boss_loop() -> void:
	while is_instance_valid(self) and current_state != State.DEAD:
		await get_tree().create_timer(2.5).timeout
		if current_state == State.IDLE:
			# LOGIKA STŘÍDÁNÍ:
			if last_attack_was_charge:
				start_smash() # Pokud minule rushoval, teď musí smashovat
			else:
				# Pokud minule smashoval, může si vybrat (50/50)
				if randi() % 2 == 0: start_smash()
				else: start_charge()

func start_charge():
	if not player: return
	current_state = State.CHARGE
	has_hit_player_this_charge = false
	last_attack_was_charge = true # Uložíme informaci o útoku
	look_at_player()
	charge_dir = direction

func start_smash():
	current_state = State.SMASH
	last_attack_was_charge = false # Resetujeme informaci (minule nebyl charge)
	velocity.x = 0
	
	sprite.play("windup")
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(2, 2, 2), 0.5)
	await get_tree().create_timer(1.0).timeout
	
	sprite.play("slam")
	sprite.modulate = Color(1, 1, 1)
	
	if slam_sound: 
		slam_player.stream = slam_sound
		slam_player.play()
	else:
		print("CHYBA: Slam Sound není přiřazen v Inspektoru!")
	if attack_particles: attack_particles.restart()
	
	check_attack_area(2)
	
	await get_tree().create_timer(1.0).timeout
	current_state = State.IDLE

func check_attack_area(damage_amount: int):
	var targets = attack_area.get_overlapping_bodies()
	for target in targets:
		if target.is_in_group("Player") and target.has_method("take_damage"):
			if current_state == State.SMASH:
				if target.is_on_floor():
					target.take_damage(damage_amount)
					print("SMASH HIT!")
			else:
				target.take_damage(damage_amount)
				print("RUSH HIT!")

func look_at_player():
	direction = 1 if player.global_position.x > global_position.x else -1
	sprite.flip_h = (direction == -1)

func take_damage(amount):
	current_health -= amount
	var tween = create_tween()
	sprite.modulate = Color(1, 0, 0)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)
	if current_health <= 0: die()

func die():
	current_state = State.DEAD
	var music = get_tree().current_scene.get_node_or_null("BossMusic")
	if music:
		var tween = create_tween()
		tween.tween_property(music, "volume_db", -80.0, 2.0)
		tween.finished.connect(music.stop)
	
	queue_free()
