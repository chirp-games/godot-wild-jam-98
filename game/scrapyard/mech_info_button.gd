@tool

extends Control

class_name MechInfoButton

signal pressed

@export var resource: MechResource:
	set(r):
		resource = r
		if name_label:
			name_label.text = resource.name
		if description_label:
			description_label.text = resource.description

@onready var name_label: Label = %Name
@onready var description_label: Label = %Description

func _ready() -> void:
	name_label.text = resource.name
	description_label.text = resource.description

func _on_button_pressed() -> void:
	pressed.emit()
