extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	move_and_slide()


func hit(body: Node2D) -> void:
	queue_free()
	body
