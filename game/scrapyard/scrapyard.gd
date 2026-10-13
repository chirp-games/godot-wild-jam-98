extends CenterContainer

@onready var pick_a_mech: PanelContainer = %PickAMech

signal mech_built(mech: MechResource)

func _on_scrapyard_scrap_pressed() -> void:
	pick_a_mech.show()

func _on_pick_a_mech_option_selected(mech: MechResource) -> void:
	pick_a_mech.hide()
	mech_built.emit(mech)
