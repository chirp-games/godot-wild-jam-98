extends GridContainer

signal set_show_tutorial(show: bool)

@export var buses: Array[StringName] = ["Master", "SFX", "Music"]

func _ready():
	tree_exited.connect(ConfigManager.on_quit)

	set_show_tutorial.emit(ConfigManager.get_value("show_tutorial", true))
	ConfigManager.on_value_set.connect(func(param, value): if param == "show_tutorial": set_show_tutorial.emit(value))

	var volume: float
	var bus_label: Label
	var bus_slider: HIconSlider
	var bus_slider_icon: TextureRect
	buses.reverse()
	for bus in buses:
		bus_label = Label.new()
		bus_label.text = bus + " volume"
		bus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		bus_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		bus_label.add_theme_font_size_override("font_size", 20)

		bus_slider = HIconSlider.new()
		bus_slider.min_value = 0
		bus_slider.max_value = 1
		bus_slider.step = 0.001
		bus_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bus_slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
		bus_slider.value_changed.connect(
			func(value: float): update_audio_volume(bus, value)
		)
		bus_slider.value_changed.connect(bus_slider._on_value_changed)
		
		bus_slider_icon = TextureRect.new()
		bus_slider_icon.texture = preload("res://assets/ui/gear_12.png")
		bus_slider_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		
		bus_slider_icon.offset_transform_enabled = true
		bus_slider_icon.offset_transform_position = Vector2(0, 10)
		bus_slider_icon.offset_transform_position_ratio = Vector2(-0.5, -0.5)
		bus_slider_icon.offset_transform_visual_only = false
		bus_slider.add_child(bus_slider_icon)

		volume = ConfigManager.get_value(
			"volume_" + bus,
			AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus))
		)
		volume = clamp(volume, 0, 1)
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), volume)
		bus_slider.value = volume
		add_child(bus_label)
		add_child(bus_slider)
		move_child(bus_slider, 0)
		move_child(bus_label, 0)

func update_audio_volume(bus: String, volume: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus)
	ConfigManager.set_value("volume_" + bus, volume)
	AudioServer.set_bus_volume_linear(bus_index, volume)

func show_tutorial_changed(value: bool) -> void:
	ConfigManager.set_value("show_tutorial", value)
