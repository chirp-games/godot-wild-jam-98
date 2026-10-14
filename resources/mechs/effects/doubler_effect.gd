extends MechPieceEffectResource

class_name ExtraBulletsEffect

@export var extra_bullets: int

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	bullet_spawner.amount += extra_bullets
	return bullet_spawner
