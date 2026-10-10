extends TextureRect

class_name DragableTextureRect


var dragging := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func _process(_delta: float) -> void:
	if dragging:
		global_position = drag_offset + get_global_mouse_position()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		scale *= 1.1
		dragging = true
		drag_offset = global_position - get_global_mouse_position()

	if event.is_action_released("left_click"):
		scale *= 1. / 1.1
		dragging = false
