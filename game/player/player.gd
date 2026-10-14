extends RigidBody2D
class_name Player

signal landed

@onready var game: Game = get_tree().get_first_node_in_group("game")

var on_floor
var floor
var can_enter_command_center_mode = false
var in_command_center_mode = false
var walking = 0.
var walk_dir: float = 0.

func on_landed() -> void:
	print("touchdown")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")

	if direction and direction != 0 and on_floor and walking <= 0:
		if sign(direction) != walk_dir:
			walk_dir = sign(direction)

	if on_floor and direction != 0:
		apply_central_impulse(Vector2(140 * walk_dir,-150))
		($Player/AnimationPlayer as AnimationPlayer).play(
			"jump_left" if walk_dir < 0 else "jump"
		)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# https://forum.godotengine.org/t/how-to-check-if-rigid-body-is-on-floor/65679/3
	var i := 0
	var was_on_floor = on_floor
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
			if not was_on_floor:
				landed.emit()
			return
		i += 1
