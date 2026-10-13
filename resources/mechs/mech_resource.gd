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

@export var detection_software: MechDetectionSoftware
