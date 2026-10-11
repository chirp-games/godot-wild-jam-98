extends Node2D

class_name BulletSpawner

const bullet = preload("res://game/bullet/Bullet.tscn")

## Keeps track of the information required to create a bullet

var amount := 1
var damage := 1
var fire_mode = false
var target_enemy: Enemy

func fire_bullets():
	for i in range(amount):
		var b: Bullet = bullet.instantiate()
		# This should be done not like this
		add_child(b)
		if fire_mode:
			b.modulate = Color(0.977, 0.317, 0.297, 1.0)
		b.target_enemy = target_enemy
		b.damage = damage
		b.scale = Vector2.ONE * damage
		await get_tree().create_timer(.1).timeout
