extends DamageableEntity

class_name CommandCenter

@onready var area2d: Node2D = %Hitbox

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy_bullet"):
		print("Attacked by enemy!")
		health -= (body as Enemy).health
		(body as Enemy).hit_command_center()


func _on_enter_command_mode_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		(body as Player).can_enter_command_center_mode = true


func _on_enter_command_mode_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		(body as Player).can_enter_command_center_mode = false
