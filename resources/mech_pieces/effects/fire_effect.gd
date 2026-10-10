extends MechPieceEffectResource

class_name FireEffect

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	bullet_spawner.fire_mode = true
	return bullet_spawner
