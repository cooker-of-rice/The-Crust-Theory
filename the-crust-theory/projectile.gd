extends Area2D

# --- NASTAVENÍ KULKY ---
@export var speed: float = 500.0 # Trochu jsem zrychlil, ať to má švih
@export var damage: int = 1
@export var bullet_lifetime: float = 1.5 # 2.7s je moc, kulka by letěla přes tři obrazovky
@export var hit_decay_time: float = 0.25  # Stačí krátké bliknutí

var direction: Vector2 = Vector2.RIGHT
var is_destroyed: bool = false

# --- ODKAZY NA UZLY ---
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
# POZOR: Pokud to nefunguje, zkontroluj jméno uzlu v projectile.tscn!
@onready var trail = get_node_or_null("Sprite2D/GPUParticles2D") 

func _ready() -> void:
	# Nastavíme vrstvy kódem, pro jistotu (Mask 1 = zdi, Mask 3 = nepřítel)
	collision_mask = 1 + 4 # Součet bitů pro vrstvy 1 a 3
	
	if trail:
		trail.emitting = true # Zapneme částice hned

	# Časovač pro automatické smazání (dostřel)
	get_tree().create_timer(bullet_lifetime).timeout.connect(_on_timeout)
	
	# Propojení signálu nárazu
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not is_destroyed:
		global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if is_destroyed: return
	
	# Pokud narazíme do nepřítele (nebo bosse), ubereme život
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	_hit_effect()

func _hit_effect() -> void:
	is_destroyed = true
	# Vypneme kolizi hned, aby kulka nepůsobila dál
	collision.set_deferred("disabled", true)
	
	if sprite:
		sprite.visible = false
	
	# Necháme částice doznít na místě nárazu
	await get_tree().create_timer(hit_decay_time).timeout
	_destroy_bullet()

func _on_timeout() -> void:
	if not is_destroyed:
		_destroy_bullet()

func _destroy_bullet() -> void:
	queue_free()
