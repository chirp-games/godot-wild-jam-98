extends RigidBody2D

class_name DragableRgidBody

@export var drag_area: Control

signal picked_up
signal dropped

var dragging := false
var disable_dragging := false
var on_floor = false
var floor

func _ready() -> void:
	drag_area.gui_input.connect(_on_gui_input)
	drag_area.self_modulate.a = 0

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if disable_dragging:
		return
	if dragging:
		linear_velocity = (get_global_mouse_position() - global_position) * 3.

func _on_gui_input(event: InputEvent) -> void:
	if disable_dragging:
		return
	if event.is_action_pressed("left_click"):
		scale *= 1.1
		dragging = true
		gravity_scale = 0.0
		picked_up.emit()

	if event.is_action_released("left_click"):
		scale *= 1. / 1.1
		dropped.emit()
		gravity_scale = 1.0
		dragging = false

	angular_damp = 100.
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# https://forum.godotengine.org/t/how-to-check-if-rigid-body-is-on-floor/65679/3
	var i := 0
	on_floor = false
	floor = null
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		#  1.0 would be perfectly straight up
		#  0.0 is a wall
		# -1.0 is a ceiling
		if normal.dot(Vector2.UP) > 0.3: # this can be dialed in
			floor = state.get_contact_collider_object(i)
			on_floor = true
		i += 1
