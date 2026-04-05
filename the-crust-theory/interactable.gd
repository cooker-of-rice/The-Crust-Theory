class_name Interactable
extends Area2D

# --- VÝBĚR TYPU INTERAKCE ---
enum InteractType { DIALOG, SCENE_CHANGE }

@export_category("Nastavení Interakce")
# Toto vytvoří roletku v Inspektoru
@export var interact_type: InteractType = InteractType.DIALOG 
@export var prompt_message: String = "Inspect"

@export_group("Pokud je to Dialog")
@export_multiline var dialog_text: String = "Zde napiš text..."

@export_group("Pokud jsou to Dveře")
# Toto ti umožní vyklikat cestu k další scéně přímo v Inspektoru
@export_file("*.tscn") var next_scene_path: String = ""

# --- SIGNÁLY A PROMĚNNÉ ---
signal interacted(player: Node2D)
var player_in_range: CharacterBody2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	# Kontrola, jestli do zóny vešel hráč
	if body is Player or body.is_in_group("Player"):
		player_in_range = body
		print("Hráč vstoupil do zóny: ", name)

func _on_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
		print("Hráč odešel ze zóny: ", name)

func _unhandled_input(event: InputEvent) -> void:
	# Pokud je hráč v zóně a zmáčkne tlačítko interact (E)
	if player_in_range and event.is_action_pressed("interact"):
		
		# 1. NEJDŘÍV označíme vstup jako vyřízený (dokud dveře ještě existují)
		get_viewport().set_input_as_handled()
		
		# 2. AŽ PAK zavoláme samotnou interakci (změnu scény)
		interact()

func interact() -> void:
	# --- ROZHODOVACÍ LOGIKA: Co se stane po stisku "E"? ---
	
	if interact_type == InteractType.DIALOG:
		# 1. VARIANTA: Je to důkaz k prozkoumání
		print("!!! INTERAKCE S DŮKAZEM: ", name, " !!!")
		print("TEXT DŮKAZU: ", dialog_text)
		
		# Pokud máš už hotové UI pro dialogy, tady bys ho zavolal.
		# Například: get_tree().call_group("UI", "show_dialog", dialog_text)
		
	elif interact_type == InteractType.SCENE_CHANGE:
		# 2. VARIANTA: Jsou to dveře do dalšího levelu
		print("!!! PRŮCHOD DVEŘMI !!!")
		if next_scene_path != "":
			print("Načítám scénu: ", next_scene_path)
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("POZOR: Není vybrána žádná další scéna v Inspektoru!")
	
	interacted.emit(player_in_range)
