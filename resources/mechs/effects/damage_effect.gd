extends MechEffectResource
class_name DamageEffect

@export var damage: int = 0

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	bullet_spawner.damage += damage
	# Bullets can not deal less than 1 damage
	if bullet_spawner.damage < 1:
		bullet_spawner.damage = 1
	return bullet_spawner
