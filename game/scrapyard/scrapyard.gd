extends CenterContainer

@onready var pick_a_mech: PanelContainer = %PickAMech

signal mech_built(mech: MechResource)

func calculate_rewards(value: float) -> Array[MechResource]:
	## Should not be allowed to meld without less than 25 value
	if value < 20:
		return []

	var out: Array[MechResource] = []

	var mech_list = Resources.mechs
	
	while value > 0:
		var next_reward_chance := 0.0
		if value > 20:
			next_reward_chance = 1.0
		else:
			next_reward_chance = float(value) / 20.

		if randf() < next_reward_chance:
			out.push_back(mech_list.pick_random())
		
		value -= 20

	return out

func set_rewards():
	pass

func _on_scrapyard_scrap_pressed(value: int) -> void:
	pick_a_mech.set_rewards(calculate_rewards(value))
	pick_a_mech.show()

func _on_pick_a_mech_option_selected(mech: MechResource) -> void:
	pick_a_mech.hide()
	mech_built.emit(mech)
