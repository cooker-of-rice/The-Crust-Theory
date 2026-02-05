extends CanvasLayer

@onready var dialog_box: Control = $DialogBox
@onready var label: Label = $DialogBox/Label

func _ready() -> void:
	# Na začátku hry okno skryjeme
	dialog_box.visible = false

# Tuto funkci volá ten příkaz get_tree().call_group(...) z Interactable.gd
func show_dialog(text: String) -> void:
	label.text = text
	dialog_box.visible = true

func _unhandled_input(event: InputEvent) -> void:
	# Pokud je okno vidět a hráč zmáčkne E nebo Skok, okno se zavře
	if dialog_box.visible:
		if event.is_action_pressed("interact") or event.is_action_pressed("jump"):
			dialog_box.visible = false
			get_viewport().set_input_as_handled() # Zabráníme skoku postavy při zavírání
