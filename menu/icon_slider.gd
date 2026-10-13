@tool
extends HSlider
class_name HIconSlider


@onready var first_child: Control = get_child(0)

func _on_value_changed(new_value: float) -> void:
	first_child.position.x = size.x * new_value / max_value

func _ready() -> void:
	await get_tree().process_frame
	first_child.position.x = size.x * value / max_value

func _draw() -> void:
	first_child.size = Vector2.ONE * size.y
	first_child.offset_transform_position.y = size.y / 2
