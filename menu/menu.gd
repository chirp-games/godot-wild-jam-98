extends Control


@export var acceleration := 2

@onready var title = %Title

func _ready() -> void:
	title.text = ProjectSettings.get_setting("application/config/name")
	if OS.has_feature("web"):
		(%WebAlert as Control).show()
		(%Quit as Control).hide()

func start_pressed() -> void:
	print("Starting the game")
	create_tween(
		).tween_property(%Start, "angular_velocity", acceleration * 5, 5
		).from_current(
		).set_ease(Tween.EASE_OUT
		).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://game/game.tscn")

func quit_pressed() -> void:
	get_tree().quit()
