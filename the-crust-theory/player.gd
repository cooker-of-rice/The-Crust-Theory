class_name Player
extends CharacterBody2D

# --- KONFIGURACE (Tuning) ---
@export_group("Movement")
@export var speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 1200.0

@export var jump_sound: AudioStream
@export var landing_sound: AudioStream
@export var wall_slide_sound: AudioStream

@onready var jump_player: AudioStreamPlayer2D = $JumpPlayer
@onready var landing_player: AudioStreamPlayer2D = $LandingPlayer
@onready var wall_slide_player: AudioStreamPlayer2D = $WallSlidePlayer

@export_group("Jump & Air")
@export var jump_velocity: float = -350.0
@export var gravity_multiplier: float = 1.2
@export var air_resistance: float = 200.0

@export_group("Wall Slide")
@export var wall_slide_speed: float = 100.0
@export var wall_gravity_multiplier: float = 0.3

@export_group("Combat")
@export var projectile_scene: PackedScene 
@export var fire_rate: float = 0.5

@export_group("Stats")
@export var max_health: int = 5
var current_health: int

@export_group("Audio")
@export var footstep_sound: AudioStream 
@onready var footstep_player: AudioStreamPlayer2D = $FootstepPlayer

# --- ODKAZY NA UZLY ---
@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var health_label: Label = $HUD/HealthLabel 
@export var shoot_sound: AudioStream 
@onready var shoot_player: AudioStreamPlayer2D = $ShootPlayer

# --- STAVOVÝ AUTOMAT ---
enum State { IDLE, RUN, AIR, WALL_SLIDE }
var current_state: State = State.IDLE

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor: bool = false
var facing_direction: float = 1.0
var can_shoot: bool = true

func _ready() -> void:
	current_health = max_health
	update_health_ui() 
	if footstep_sound:
		footstep_player.stream = footstep_sound
	
	# Kamera je nyní standardně na hráči bez jakýchkoliv okolků
	if camera:
		camera.top_level = false
		camera.position = Vector2.ZERO

func _play_sound(player: AudioStreamPlayer2D, sound: AudioStream):
	if sound and player:
		player.stream = sound
		player.pitch_scale = randf_range(0.9, 1.1)
		player.play()

func _handle_impact_sound(impact_speed: float):
	if impact_speed > 100.0:
		# Pokud má tvá kamera skript pro otřesy (add_trauma), vyvoláme ho
		if camera and camera.has_method("add_trauma"):
			camera.add_trauma(0.25)
		_play_sound(landing_player, landing_sound)

func play_footstep():
	if is_on_floor() and velocity.x != 0 and not footstep_player.playing:
		footstep_player.pitch_scale = randf_range(0.8, 1.2)
		footstep_player.play()

# --- HLAVNÍ LOOP ---
func _physics_process(delta: float) -> void:
	# 1. ZÍSKÁNÍ VSTUPU
	var direction: float = Input.get_axis("move_left", "move_right")
	
	# 2. OTÁČENÍ POSTAVY
	if direction != 0:
		facing_direction = sign(direction)
		sprite.flip_h = (facing_direction == -1)
	
	# 3. ZPRACOVÁNÍ POHYBU A BOJE
	apply_gravity(delta)
	handle_wall_slide(delta, direction)
	handle_movement(delta, direction)
	handle_jump()
	handle_combat()
	
	# 4. PROVEDENÍ POHYBU
	move_and_slide()
	
	# 5. LOGIKA ZVUKŮ
	if current_state == State.RUN and is_on_floor():
		play_footstep()
	else:
		if footstep_player.playing:
			footstep_player.stop()
			
	if current_state == State.WALL_SLIDE:
		if not wall_slide_player.playing:
			_play_sound(wall_slide_player, wall_slide_sound)
	else:
		if wall_slide_player.playing:
			wall_slide_player.stop()

	if is_on_floor() and not was_on_floor:
		var impact_speed = get_real_velocity().y
		_handle_impact_sound(impact_speed)

	was_on_floor = is_on_floor()
	update_state()

# --- LOGIKA UI ---
func update_health_ui() -> void:
	if health_label:
		health_label.text = "ŽIVOTY: " + str(current_health) + " / " + str(max_health)

# --- BOJ ---
func handle_combat() -> void:
	# Střílíme jen pokud hráč stiskne tlačítko a není v cooldownu
	if Input.is_action_just_pressed("shoot") and can_shoot:
		can_shoot = false 
		
		# 1. ZVUK VÝSTŘELU
		if shoot_sound:
			shoot_player.stream = shoot_sound
			shoot_player.pitch_scale = randf_range(0.9, 1.1) # Každý výstřel zní trochu jinak
			shoot_player.play()
		
		# 2. ZPĚTNÝ RÁZ (Recoil)
		# Miller při výstřelu lehce "cukne" dozadu
		var recoil_direction = -1 if not sprite.flip_h else 1
		velocity.x += recoil_direction * 180.0 # Síla kopnutí zbraně
		
		# 3. OTŘES KAMERY (Screen Shake)
		# Pokud má tvoje kamera skript s funkcí add_trauma
		if camera and camera.has_method("add_trauma"):
			camera.add_trauma(0.3) # 0.3 je slušná rána
			
		# 4. VYTVOŘENÍ KULKY (Projectile)
		var bullet = projectile_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		
		# Nastavení pozice a směru kulky podle toho, kam Miller kouká
		if sprite.flip_h: # Kouká doleva
			bullet.direction = Vector2.LEFT
			bullet.global_position = global_position + Vector2(-35, -12) # Úprava k hlavni
		else: # Kouká doprava
			bullet.direction = Vector2.RIGHT
			bullet.global_position = global_position + Vector2(35, -12)
			
		# 5. ANIMACE VÝSTŘELU
		sprite.play("shoot")
		
		# 6. COOLDOWN (Rychlost střelby)
		await get_tree().create_timer(fire_rate).timeout
		
		# Pokud po výstřelu hráč stojí a nic nemačká, vrátíme se do idle
		if is_on_floor() and is_zero_approx(velocity.x):
			sprite.play("idle")
			
		can_shoot = true

func take_damage(damage: int) -> void:
	current_health -= damage
	update_health_ui()
	var tween = create_tween()
	sprite.modulate = Color(1, 0.2, 0.2)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)
	if current_health <= 0:
		die()

func die() -> void:
	# find_child najde DeathScreen, i když je teď pod kamerou
	var ds = find_child("DeathScreen") 
	
	if ds:
		ds.show_death_screen()
		# Miller "zmizí", ale kamera a její potomci (UI) zůstanou
		set_physics_process(false) 
		sprite.hide()
		# POZOR: Stále zde NESMÍ být queue_free()
	else:
		print("CHYBA: DeathScreen pod kamerou nenalezen!")
		get_tree().change_scene_to_file("res://office.tscn")
# --- LOGIKA POHYBU ---
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if current_state != State.WALL_SLIDE:
			velocity.y += gravity * gravity_multiplier * delta

func handle_movement(delta: float, direction: float) -> void:
	if current_state == State.WALL_SLIDE:
		return 
	var target_accel = acceleration if is_on_floor() else air_resistance
	var target_friction = friction if is_on_floor() else air_resistance
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, target_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, target_friction * delta)

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			_play_sound(jump_player, jump_sound)
		elif current_state == State.WALL_SLIDE:
			var wall_normal = get_wall_normal()
			velocity.y = jump_velocity * 0.9
			velocity.x = wall_normal.x * speed * 1.5
			_play_sound(jump_player, jump_sound)

func handle_wall_slide(delta: float, direction: float) -> void:
	if is_on_wall_only() and velocity.y > 0:
		var pushing_against_wall = (direction != 0) and (sign(direction) != sign(get_wall_normal().x))
		if pushing_against_wall:
			current_state = State.WALL_SLIDE
			velocity.y = min(velocity.y + (gravity * wall_gravity_multiplier * delta), wall_slide_speed)
			return
	if current_state == State.WALL_SLIDE:
		current_state = State.AIR

func update_state() -> void:
	if current_state == State.WALL_SLIDE:
		return 
	if is_on_floor():
		if is_zero_approx(velocity.x):
			current_state = State.IDLE
		else:
			current_state = State.RUN
	else:
		current_state = State.AIR
