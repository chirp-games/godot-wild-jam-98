@tool
extends Control
class_name DefaultTooltip

@export var around: Node

func _ready() -> void:
	%Tooltip.show_when_hovering = around
	%Tooltip.around = around
	%Tooltip.avoid_overlap.push_back(around)

	%Hints.show_when_hovering = around
	%Hints.around = %MainTooltip
	%Hints.avoid_overlap.push_back(around)

	%Hints.queue_free()

func make_mech_piece_tooltip(name: String):
	%MainTooltip.tooltip_name = name
	%MainTooltip.tooltip_description = ""
