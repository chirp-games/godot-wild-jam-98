extends Node2D

class_name BulletSpawner

const bullet = preload("res://game/bullet/Bullet.tscn")

## Keeps track of the information required to create a bullet

var amount := 1
var target_enemy: Enemy

func fire_bullets():
	for i in range(amount):
		var b: Bullet = bullet.instantiate()
		# This should be done not like this
		add_child(b)
		b.target_enemy = target_enemy
		await get_tree().create_timer(.1).timeout
