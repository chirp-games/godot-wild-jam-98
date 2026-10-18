extends PanelContainer

var buttons = []

@onready var mech_info_button: InstancePlaceholder = %MechInfoButton

signal option_selected(mech: MechResource)

func set_rewards(rewards: Array[MechResource]):
	for b in buttons:
		b.queue_free()
	buttons = []
	
	for r in rewards:
		var m: MechInfoButton = mech_info_button.create_instance()
		m.resource = r
		m.pressed.connect(func():
			option_selected.emit(mech_info_button.resource)
			)
		buttons.push_back(m)
