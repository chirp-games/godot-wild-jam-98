extends DragableTextureRect

class_name MechPiece

signal wire_started
signal wire_ended

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		wire_started.emit()
	if event.is_action_released("right_click"):
		wire_ended.emit()
	super._on_gui_input(event)
