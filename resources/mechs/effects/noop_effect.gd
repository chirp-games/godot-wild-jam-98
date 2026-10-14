extends MechEffectResource

class_name NoopEffect

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	return bullet_spawner
