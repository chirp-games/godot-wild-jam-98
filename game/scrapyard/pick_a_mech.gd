extends PanelContainer

signal option_selected(mech: MechResource)

func _ready() -> void:
	for mech_info_button: MechInfoButton in $HBoxContainer.get_children():
		mech_info_button.pressed.connect(func():
			option_selected.emit(mech_info_button.resource)
			)
