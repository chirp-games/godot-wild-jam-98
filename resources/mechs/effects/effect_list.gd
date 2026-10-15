extends MechEffectResource

class_name MechEffectList

@export var effects: Array[MechEffectResource]

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	for e in effects:
		bullet_spawner = e.apply(bullet_spawner)
	return bullet_spawner
