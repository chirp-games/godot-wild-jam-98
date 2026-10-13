@tool

extends Control

class_name MechInfoButton

signal pressed

@export var resource: MechResource

@onready var name_label: Label = %Name
@onready var description_label: Label = %Description

func _ready() -> void:
	name_label.text = resource.name
	description_label.text = resource.description


func _on_button_pressed() -> void:
	pressed.emit()
