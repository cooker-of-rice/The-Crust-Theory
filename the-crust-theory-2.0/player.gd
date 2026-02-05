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

# --- ODRAZY NA UZLY ---
# Očekáváme, že kamera je přímým potomkem hráče a jmenuje se "Camera2D"
@onready var camera: Camera2D = $Camera2D

# --- STAVOVÝ AUTOMAT ---
enum State { IDLE, RUN, AIR, WALL_SLIDE }
var current_state: State = State.IDLE

# Proměnné pro logiku
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor: bool = false # Pamatuje si, zda jsme byli na zemi v minulém snímku

# --- HLAVNÍ LOOP ---
func _physics_process(delta: float) -> void:
	# 1. Zpracování inputu
	var direction: float = Input.get_axis("move_left", "move_right")
	
	# 2. Aplikace gravitace
	apply_gravity(delta)
	
	# 3. Wall Slide logika
	handle_wall_slide(delta, direction)
	
	# 4. Pohyb a skok
	handle_movement(delta, direction)
	handle_jump()
	
	# 5. Aplikace fyziky (pohyb samotný)
	move_and_slide()
	
	# 6. EFEKT DOPADU (Shake)
	# Pokud jsme teď na zemi, ale předtím jsme nebyli -> právě jsme dopadli
	if is_on_floor() and not was_on_floor:
		# Zavoláme otřes kamery (pokud kamera existuje)
		if camera and camera.has_method("add_trauma"):
			# Hodnota 0.25 je síla otřesu (0.0 až 1.0)
			camera.add_trauma(0.25)
	
	# Uložíme stav pro příští snímek
	was_on_floor = is_on_floor()
	
	# 7. Určení stavu pro animace
	update_state()

# --- LOGIKA ---

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
