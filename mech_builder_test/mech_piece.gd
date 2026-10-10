extends DragableTextureRect

class_name MechPiece

signal wire_started
signal wire_ended
signal delete_wire

var started_clicking_at: Vector2
var idk_what_to_call_this = false

# Wires must go from a send type to a recv type
enum Type {
	Male,
	Female,
}

@export var type: Type = Type.Male

func _process(_delta: float) -> void:
	if Input.is_action_pressed("right_click") and get_global_mouse_position() != started_clicking_at and idk_what_to_call_this:
		wire_started.emit()
		idk_what_to_call_this = false
	super._process(_delta)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		started_clicking_at = get_global_mouse_position()
		idk_what_to_call_this = true
	if event.is_action_released("right_click"):
		wire_ended.emit()
		if get_global_mouse_position() == started_clicking_at:
			delete_wire.emit()
	super._on_gui_input(event)
