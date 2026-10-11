extends MechPieceEffectResource
class_name DamageEffect

@export var damage: int

func apply(bullet_spawner: BulletSpawner) -> BulletSpawner:
	bullet_spawner.damage += damage
	return bullet_spawner
