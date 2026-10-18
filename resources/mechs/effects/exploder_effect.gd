extends MechEffectResource

class_name ExploderEffect

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	bullet_spawner.explosive = true
	return bullet_spawner
