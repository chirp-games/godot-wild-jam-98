extends MechDetectionSoftware

class_name DetectCompose

@export var detectors: Array[MechDetectionSoftware]

func detect(position: Vector2, enemies: Array[Enemy]) -> Array[Enemy]:
	for d in detectors:
		enemies = d.detect(position, enemies)
	return enemies
