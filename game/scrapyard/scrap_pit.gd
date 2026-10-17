extends HSplitContainer
class_name ScrapPit

signal remove_enemy(enemy: EnemyResource)

@onready var scrap_enemy_corpse: InstancePlaceholder = %ScrapEnemyCorpse

var corpses: Array[ScrapEnemyCorpse] = []

func add_enemy(enemy: EnemyResource):
	var corpse: ScrapEnemyCorpse = scrap_enemy_corpse.create_instance()
	corpse.set_enemy(enemy)
	corpse.on_click.connect(
		func():
			remove_enemy.emit(enemy)
			corpse.queue_free()
	)
	corpse.global_position = %AddCorpse.global_position
	corpse.global_position.x += randf_range(-30, 30)
	corpses.push_back(corpse)

func empty_pit():
	for c in corpses:
		c.queue_free()
	corpses = []

func _process(delta: float) -> void:
	var total_scrap_value = 0
	for c in corpses:
		if not c:
			continue
		total_scrap_value += c.scrap_value

	%ProgressBar.value = total_scrap_value / 200.
