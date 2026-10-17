extends PanelContainer

signal scrap_pressed(value: float)

@onready var scrap_enemy_component: InstancePlaceholder = %ScrapEnemyComponent

@onready var game: Game = get_tree().get_first_node_in_group("game")
@onready var scrap_pit: ScrapPit = %ScrapPit

var scrap_enemy_components: Dictionary[EnemyResource, ScrapEnemyComponent] = {}

func _ready() -> void:
	create_instances_for_all_enemies()
	if game:
		game.enemy_corpse_amount_updated.connect(func(x): 
			for k in scrap_enemy_components.keys():
				var c := scrap_enemy_components[k]
				c.amount_in_storage = x[k]
		)
	
	if not game:
		set_up_test_ui()

func set_up_test_ui():
	var rat_corpse: EnemyResource = load("res://resources/enemy/rat.tres")
	scrap_enemy_components[rat_corpse].amount_in_storage = 10

func create_instances_for_all_enemies():
	for e in Resources.enemies:
		var s: ScrapEnemyComponent = scrap_enemy_component.create_instance()
		s.enemy = e
		scrap_enemy_components[e] = s
		
		s.add_corpse.connect(func(): _add_corpse(s))

func get_total_points() -> int:
	var total_points := 0
	for s: ScrapEnemyComponent in scrap_enemy_components.values():
		total_points += s.get_total_points()
	return total_points

func _add_corpse(s: ScrapEnemyComponent):
	scrap_pit.add_enemy(s.enemy)

## When the player presses scrap, they get 1 of 3 rewards to pick from.
## Its a pick 3! Yay!
func _on_scrap_button_pressed() -> void:
	# Remove the corpses used in this scrapping
	var total_value = 0
	for k in scrap_enemy_components.keys():
		var c := scrap_enemy_components[k]
		total_value += c.get_total_points()
		# Update game, if it exists. Does not exist when running scene on its own.
		if game:
			game.enemy_corpses_collected[k] -= c.scrap_quantity
		# And reset the UI
		c.amount_in_storage = game.enemy_corpses_collected[k]
		c.scrap_quantity = 0
		scrap_pit.empty_pit()

	scrap_pressed.emit(total_value)


func _on_scrap_pit_remove_enemy(enemy: EnemyResource) -> void:
	scrap_enemy_components[enemy].scrap_quantity -= 1
