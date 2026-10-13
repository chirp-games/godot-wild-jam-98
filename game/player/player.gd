extends RigidBody2D

class_name Player

@onready var game: Game = get_tree().get_first_node_in_group("game")
@onready var skeleton: Skeleton2D = %Skeleton

var on_floor
var floor
var can_enter_command_center_mode = false
var in_command_center_mode = false
var walking = 0.
var walk_dir: float = 0.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	walking -= 1
	var direction: float = Input.get_axis("l", "r")
	
	if direction and direction != 0 and on_floor and walking <= 0:
		walking = 60
		if sign(direction) != walk_dir:
			walk_dir = sign(direction)
	if walking > 35:
		self.apply_central_force(Vector2(700 * walk_dir,-1500))
	

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
