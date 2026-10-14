extends Node2D

class_name CommandCenter

@onready var area2d: Node2D = %Hitbox
@onready var take_damage: TakeDamage = %TakeDamage

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy_bullet"):
		(body as Enemy).hit_command_center()


func _on_enter_command_mode_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		(body as Player).can_enter_command_center_mode = true


func _on_enter_command_mode_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("player"):
		(body as Player).can_enter_command_center_mode = false

func get_health():
	return take_damage.health
