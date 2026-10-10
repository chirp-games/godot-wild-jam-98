extends CharacterBody2D

@onready var sprite: Sprite2D = %Sprite2D

signal create_projectile(chain: Array[MechPiece], target: Enemy)

@onready var player_camera: Camera2D = %PlayerCamera

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var in_build_mode: bool = false

var d = 1.


func enter_build_mode():
	in_build_mode = true
	player_camera.zoom = Vector2(5.0, 5.0)

func exit_build_mode():
	in_build_mode = false
	player_camera.zoom = Vector2(1.0, 1.0)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter_build_mode"):
		if not in_build_mode:
			enter_build_mode()
		else:
			exit_build_mode()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		d = direction
		sprite.scale.x = d
	
	move_and_slide()


func _on_mech_builder_create_projectile(chain: Array, target: Enemy) -> void:
	create_projectile.emit(chain, target)
	
	
