extends MechPiece

@onready var detector: Area2D = %Detector

## This sensor will trigger when there is a close enemy

func _process(_delta: float) -> void:
	detected_target = null
	for body in detector.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			detected_target = body
	super._process(_delta)
