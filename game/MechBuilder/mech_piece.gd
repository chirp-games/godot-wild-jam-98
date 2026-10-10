extends DragableTextureRect

class_name MechPiece

@onready var red: WireReceptacle = %Red
@onready var blue: WireReceptacle = %Blue

## Signal that an enemy is detected that needs to be fired at!
signal activate

func get_receptacles():
	var out: Array[WireReceptacle] = []
	if red.visible:
		out.push_back(red)
	if blue.visible:
		out.push_back(blue)
	return out

func get_blue_receptacle() -> WireReceptacle:
	if blue.visible:
		return blue
	return null
