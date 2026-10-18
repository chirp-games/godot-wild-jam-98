extends Resource

class_name MechResource

enum MechClass {
	Recruit,
	Lieutenant,
	Commander,
}

enum Rarity {
	Common,
	Uncommon,
	Rare,
}

@export var name: String = "Mech"
@export var mech_class: MechClass = MechClass.Recruit
@export var rarity: Rarity = Rarity.Common
@export_multiline var description: String = ""

@export var healing: int = 0

@export_category("Pathfinding")
@export var pathfinding: PathfindingResource

@export_category("Effects")
## Cooldown in scales of .1
@export var cooldown_ratio: int
@export var effect: MechEffectResource

@export_category("Detection")
@export var detection_software: MechDetectionSoftware
