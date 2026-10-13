extends Control


@onready var title = %Title

func _ready() -> void:
	title.text = ProjectSettings.get_setting("application/config/name")

func start_pressed() -> void:
	print("Starting the game")

func quit_pressed() -> void:
	get_tree().quit()
