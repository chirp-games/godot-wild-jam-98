extends Node2D

@onready var t1: RigidBody2D = %t1
@onready var t2: RigidBody2D = %t2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	
	for j in [%p1,%p2]:
		j.motor_enabled = true if direction else false
		if direction:
			j.motor_target_velocity = 40 * direction
	
	#print("t1 ", t1.angular_velocity)
