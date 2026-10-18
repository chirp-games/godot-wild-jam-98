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
	ResourceLoader.load_threaded_request("res://game/game.tscn")

func quit_pressed() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	if ResourceLoader.load_threaded_get_status("res://game/game.tscn") == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://game/game.tscn"))
