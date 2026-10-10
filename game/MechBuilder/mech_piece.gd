extends DragableTextureRect

class_name MechPiece

@onready var red: WireReceptacle = %Red
@onready var blue: WireReceptacle = %Blue
@onready var cooldown_bar: ProgressBar = %CooldownBar

@export var cooldown = .5
var cooldown_charge = 0.0

## Signal that an enemy is detected that needs to be fired at!
signal activate(target: Enemy)

func _process(delta: float) -> void:
	cooldown_bar.value = cooldown_charge / cooldown
	super._process(delta)

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

## Mech pieces that can start a chain only have the blue port visible
func is_start_of_chain():
	return not red.visible

## Return true if the cooldown on this part is over
func is_ready():
	return cooldown_charge >= cooldown
