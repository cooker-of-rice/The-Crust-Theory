class_name Player
extends CharacterBody2D

# --- KONFIGURACE (Tuning) ---
@export_group("Movement")
@export var speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 1200.0

@export_group("Jump & Air")
@export var jump_velocity: float = -350.0
@export var gravity_multiplier: float = 1.2
@export var air_resistance: float = 200.0

@export_group("Wall Slide")
@export var wall_slide_speed: float = 100.0
@export var wall_gravity_multiplier: float = 0.3

@export_group("Combat")
# Zde v editoru vložíme scénu našeho projektilu
@export var projectile_scene: PackedScene 

# --- ODRAZY NA UZLY ---
@onready var camera: Camera2D = $Camera2D
@onready var sprite: Sprite2D = $Sprite2D # Potřebujeme pro otáčení grafiky

# --- STAVOVÝ AUTOMAT A LOGIKA ---
enum State { IDLE, RUN, AIR, WALL_SLIDE }
var current_state: State = State.IDLE

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor: bool = false
var facing_direction: float = 1.0 # 1 = doprava, -1 = doleva (důležité pro střelbu)

# --- HLAVNÍ LOOP ---
func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	
	# OTÁČENÍ POSTAVY (Flipping)
	if direction != 0:
		facing_direction = sign(direction)
		# Pokud jdeme doleva (-1), zapneme flip_h. Jinak vypneme.
		sprite.flip_h = (facing_direction == -1)
	
	apply_gravity(delta)
	handle_wall_slide(delta, direction)
	handle_movement(delta, direction)
	handle_jump()
	handle_combat() # Zpracování střelby
	
	move_and_slide()
	
	# EFEKT DOPADU
	if is_on_floor() and not was_on_floor:
		if camera and camera.has_method("add_trauma"):
			var impact_speed = get_real_velocity().y
			if impact_speed > 100.0:
				camera.add_trauma(0.25)
	
	was_on_floor = is_on_floor()
	update_state()

# --- LOGIKA ---

func handle_combat() -> void:
	# Pokud zmáčkneme střelbu a máme nahranou scénu projektilu
	if Input.is_action_just_pressed("shoot") and projectile_scene:
		var proj = projectile_scene.instantiate()
		# Přidáme projektil do aktuálního světa (aby necestoval s hráčem, když hráč uhne)
		get_tree().current_scene.add_child(proj)
		
		# Nastavíme startovní pozici projektilu na střed hráče
		proj.global_position = global_position
		# Můžeme projektil trochu posunout dopředu, aby se nespawnoval v břiše
		proj.global_position.x += facing_direction * 20.0
		
		# Řekneme projektilu, kam má letět
		proj.direction = Vector2(facing_direction, 0)

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
		elif current_state == State.WALL_SLIDE:
			var wall_normal = get_wall_normal()
			velocity.y = jump_velocity * 0.9
			velocity.x = wall_normal.x * speed * 1.5

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
