@tool
extends Button
class_name CogButton
## A button with a spinning cog on the right of it.[br][br]
##
##
## When hovered, the cog spins clockwise, and when unhovered it spins back.
## The cog also spins at a constant velocity when not changing state.


## The cog's rotational velocity in [i]radians[/i] per second.
@export var angular_velocity := 0. :
	set(value) :
		_actual_angular_velocity = value
		angular_velocity = value
## When true, the cog will stop rotating when held down.
@export var stop_on_down := false
## The cog's uniform scale. It's default size is 60x60px,
## which is the correct size for a font size of 16
@export var cog_scale := 1. :
	set(value):
		cog_scale = value
		($Control as Control).offset_transform_scale = Vector2.ONE * cog_scale
		($Control2 as Control).offset_transform_scale = Vector2.ONE * cog_scale

# The current tween running to rotate the cog. When set, constant rotation will not be applied
# as it would be overwritten by the tween.
var _tween: Tween
# The current actual angular velocity of the cog. This is used so pressing on the button can
# temporarily stop the rotation, then return it to the correct value.
var _actual_angular_velocity := angular_velocity

## Applies a smooth rotation to the cog, in [i]radians[/i], starting from it's current rotation.[br]
## [b]Note:[/b] [property angular_velocity] does not apply whilst the rotation is taking place.
func rotate_cog(degrees: float, duration: float = 0.5) -> void:
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(
		%Left, "offset_transform_rotation", degrees, duration
	).as_relative()
	_tween.parallel().tween_property(
		%Right, "offset_transform_rotation", degrees, duration
	).as_relative()
	_tween.tween_callback(func(): _tween = null)

func _mouse_down() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "_actual_angular_velocity", 0, 0.1)

func _mouse_up() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "_actual_angular_velocity", angular_velocity, 0.1)

func _hovered() -> void:
	rotate_cog(deg_to_rad(90))

func _unhovered() -> void:
	rotate_cog(deg_to_rad(-90))

func _process(delta: float) -> void:
	if not _tween:
		rotate_cog(delta * _actual_angular_velocity, 0)
