extends PanelContainer

signal scrap_pressed

@onready var commander_percent_chance_lbael = %CommanderPercentChance
@onready var lieuetentant_precent_chance_label = %LiuetenantPercentChance
@onready var recruit_percent_chance_label = %RecruitPercentChance

## Given a certain amount of points, what should the base reward chance be
## NOTE: This may be further modified by special enemy scrap options in the future
func calculate_reward_percent(points: int) -> Array[float]:
	var commander_chance = min(int(points / 3.), 100)
	var lieutentant_chance = min(max(points - int(points / 3.), 0), 100 - commander_chance)
	var recruit_chance = max(100 - commander_chance - lieutentant_chance, 0)

	return [commander_chance / 100., lieutentant_chance / 100., recruit_chance / 100.]

func get_total_points() -> int:
	var total_points := 0
	for s: ScrapEnemyComponent in %"Scrap Menu".get_children():
		total_points += s.get_total_points()
	return total_points


func _process(_delta: float) -> void:
	var p := calculate_reward_percent(get_total_points())
	commander_percent_chance_lbael.text = str(int(p[0] * 100)) + "%"
	lieuetentant_precent_chance_label.text = str(int(p[1] * 100)) + "%"
	recruit_percent_chance_label.text = str(int(p[2] * 100)) + "%"
	

## When the player presses scrap, they get 1 of 3 rewards to pick from.
## Its a pick 3! Yay!
func _on_scrap_button_pressed() -> void:
	scrap_pressed.emit()
