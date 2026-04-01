class_name Projectile
extends Area2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.RIGHT # Defaultně letí doprava

func _ready() -> void:
	# Připojíme signál, když projektil do něčeho narazí
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Jednoduchý posun rovně podle směru a rychlosti
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Pokud narazíme do nepřítele, zničíme ho
	if body is Enemy:
		body.queue_free() # Později sem přidáme funkci jako body.take_damage()
		
	# Bez ohledu na to, do čeho projektil narazil (nepřítel nebo zeď), se zničí
	# Pokud chceme, aby ignoroval hráče, přidáme kontrolu: if body is Player: return
	if body is Player:
		return
		
	queue_free() # Zničí projektilextends Area2D
