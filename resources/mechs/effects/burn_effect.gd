extends MechEffectResource

class_name BurnEffect

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	bullet_spawner.fire_mode = true
	return bullet_spawner
