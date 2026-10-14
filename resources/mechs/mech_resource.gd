extends Resource

class_name MechResource

enum MechClass {
	Recruit,
	Lieutenant,
	Commander,
}

@export var name: String = "Mech"
@export var mech_class: MechClass = MechClass.Recruit
@export_multiline var description: String = ""

@export_category("Effects")
## Cooldown in scales of .1
@export var cooldown_ratio: int
@export var effect: MechEffectResource

@export_category("Detection")
@export var detection_software: MechDetectionSoftware
