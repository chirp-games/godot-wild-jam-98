extends CharacterBody2D

class_name DragableCharacterBody

@export var drag_area: Control

signal picked_up
signal dropped

var grid_size = Vector2(1, 1)
var dragging := false
var drag_offset := Vector2.ZERO
var disable_dragging := false

func _ready() -> void:
	drag_area.gui_input.connect(_on_gui_input)
	drag_area.self_modulate.a = 0

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if disable_dragging:
		return
	if dragging:
		position = floor((drag_offset + get_global_mouse_position()) / grid_size) * grid_size
		velocity = Vector2.ZERO

func _on_gui_input(event: InputEvent) -> void:
	if disable_dragging:
		return
	if event.is_action_pressed("left_click"):
		scale *= 1.1
		dragging = true
		picked_up.emit()
		drag_offset = floor((position - get_global_mouse_position()) / grid_size) * grid_size + grid_size

	if event.is_action_released("left_click"):
		scale *= 1. / 1.1
		dropped.emit()
		dragging = false
