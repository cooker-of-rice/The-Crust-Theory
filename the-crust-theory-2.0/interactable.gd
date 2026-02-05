class_name Interactable
extends Area2D

# --- 1. SIGNÁLY A PROMĚNNÉ ---
# Signál, který můžeme použít pro jiné skripty
signal interacted(player: Node2D)

@export var prompt_message: String = "Inspect"

# TOTO je ta proměnná, která ti chyběla. 
# @export_multiline umožní psát delší texty v Inspektoru.
@export_multiline var dialog_text: String = "Zajímavé... ale co to znamená?"

# Odkaz na vizuální nápovědu (Label nebo Sprite "E")
@onready var prompt_visual: Node2D = $Prompt 

# Proměnná pro uložení hráče, když je v dosahu
var player_in_range: Player = null

# --- 2. ZÁKLADNÍ NASTAVENÍ ---
func _ready() -> void:
	# Propojíme signály vstupu a výstupu z oblasti
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Na začátku skryjeme nápovědu "E"
	if prompt_visual:
		prompt_visual.visible = false

# --- 3. DETEKCE HRÁČE ---
func _on_body_entered(body: Node2D) -> void:
	# Kontrola, zda vstoupil Hráč (díky class_name Player)
	if body is Player:
		print("Hráč vstoupil do zóny: ", name)
		player_in_range = body
		if prompt_visual:
			prompt_visual.visible = true

func _on_body_exited(body: Node2D) -> void:
	# Pokud hráč odešel, zrušíme odkaz a skryjeme nápovědu
	if body == player_in_range:
		print("Hráč odešel z zóny: ", name)
		player_in_range = null
		if prompt_visual:
			prompt_visual.visible = false

# --- 4. ZPRACOVÁNÍ VSTUPU (Tlačítko E) ---
func _unhandled_input(event: InputEvent) -> void:
	# Podmínka: Hráč musí být v dosahu A zmáčknout klávesu "interact"
	if player_in_range and event.is_action_pressed("interact"):
		interact()
		get_viewport().set_input_as_handled() # Zabráníme dalšímu zpracování (např. skoku)

# --- 5. LOGIKA INTERAKCE ---
func interact() -> void:
	print("!!! INTERAKCE S DŮKAZEM: ", name, " !!!")
	
	# Zde voláme UI. Pokud UI scénu ještě nemáš, tento řádek nic neudělá (nezhroutí hru).
	# Jakmile UI vytvoříš a přidáš do skupiny "UI", začne to fungovat.
	get_tree().call_group("UI", "show_dialog", dialog_text)
	
	# Emitujeme signál pro případné další použití
	interacted.emit(player_in_range)
