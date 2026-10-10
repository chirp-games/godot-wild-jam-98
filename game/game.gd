extends Node2D

const Bullet = preload("res://game/bullet/Bullet.tscn")

@onready var player: Node2D = %Player

func _ready() -> void:
	print("Hello from game!")


func _on_placeholder_create_projectile(chain: Array, target: Enemy) -> void:
	var b: BulletSpawner = BulletSpawner.new()
	%BulletSpawner.add_child(b)
	b.target_enemy = target
	b.global_position = player.position + Vector2(100, -15)
	
	for p: MechPiece in chain:
		b = p.resource.effect.apply(b)
	
	await b.fire_bullets()
