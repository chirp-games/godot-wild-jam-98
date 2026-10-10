extends DragableTextureRect

class_name MechPiece

## Emitted when the player clicks to make a wire.
signal wire_started
signal wire_ended

## When the mech piece needs to send a signal.
## Should only be activated by male ends.
signal trigger

@onready var label: Label = %Label

enum Type {
	Male,
	Female,
}
@export var type: Type = Type.Male

func activate():
	print(get_path())

func _ready() -> void:
	if type == Type.Male:
		label.text = "Male"
	if type == Type.Female:
		label.text = "Female"

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		trigger.emit()
	if event.is_action_pressed("right_click"):
		wire_started.emit()
	if event.is_action_released("right_click"):
		wire_ended.emit()
	super._on_gui_input(event)
