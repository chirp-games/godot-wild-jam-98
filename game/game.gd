extends Node2D

const Bullet = preload("res://game/bullet/Bullet.tscn")

func _ready() -> void:
	print("Hello from game!")


func _on_placeholder_create_projectile(chain: Array, target: Enemy) -> void:
	var b: Bullet = Bullet.instantiate()
	add_child(b)
	b.target_enemy = target
	b.global_position = chain[-1].global_position
