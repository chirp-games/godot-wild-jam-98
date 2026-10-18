extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	move_and_slide()

func hit(body: Node2D) -> void:
	Vfx.create_vfx(Vfx.VFX_METAL_SPARK, self.global_position, self.velocity.angle())
	queue_free()
	body
