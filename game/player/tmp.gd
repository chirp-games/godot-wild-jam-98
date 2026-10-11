extends RigidBody2D

var on_floor
var floor
var n

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		self.apply_torque(direction * 99999)
	
	# https://forum.godotengine.org/t/how-to-check-if-rigid-body-is-on-floor/65679/3
	var i := 0
	on_floor = false
	floor = null
	print(state.get_contact_count())
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		#  1.0 would be perfectly straight up
		#  0.0 is a wall
		# -1.0 is a ceiling
		floor = state.get_contact_collider_object(i)
		on_floor = true
		n = normal
		i += 1
	print(n)
	if n:
		(%Angle as Sprite2D).global_position = n * 200
		
