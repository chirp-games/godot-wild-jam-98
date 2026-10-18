extends Enemy

## Signalers create a flare after some time. Then after another delay,
## reinforcements come.

@onready var flare: InstancePlaceholder = %Flare

var flare_instance: Flare = null
var flare_cd: float = 0.5

## They don't move at all for now
func pathfind(delta: float):
	flare_cd -= delta
	if not flare_instance and not is_stunned() and flare_cd <= 0 and not parachute.visible:
		flare_cd = 37
		flare_instance = flare.create_instance()
		flare_instance.decayed.connect(func():
			summon_reinforcements.emit()
			flare_instance = null
			)

func stun():
	super.stun()
	if flare_instance:
		flare_instance.queue_free()

func _on_take_damage_death() -> void:
	if flare_instance:
		flare_instance.fade_out()
	super._on_take_damage_death()

func _on_stun_timer_timeout() -> void:
	pass
