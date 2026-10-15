extends Enemy

## Signalers create a flare after some time. Then after another delay,
## reinforcements come.

@onready var flare: InstancePlaceholder = %Flare

var flare_instance: Flare = null
var reinforcements_summoned = false

## They don't move at all for now
func pathfind(_delta: float):
	if reinforcements_summoned:
		return
	if not flare_instance and not is_stunned():
		flare_instance = flare.create_instance()
		flare_instance.decayed.connect(func():
			summon_reinforcements.emit()
			flare_instance = null
			reinforcements_summoned = true
			)

func stun():
	super.stun()
	if flare_instance:
		flare_instance.queue_free()

func _on_stun_timer_timeout() -> void:
	pass
