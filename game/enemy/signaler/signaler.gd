extends Enemy

## Signalers create a flare after some time. Then after another delay,
## reinforcements come.

@onready var reinforecments_timer: Timer = %ReinforcementsTimer
@onready var summon_timer: Timer = %SummonTimer
@onready var flare: InstancePlaceholder = %Flare

var flare_instance = null

## They don't move at all for now
func pathfind(_delta: float):
	pass

func _on_reinforcements_timer_timeout() -> void:
	summon_timer.start()
	flare_instance = flare.create_instance()

func _on_time_to_summon_timeout() -> void:
	summon_reinforcements.emit()
