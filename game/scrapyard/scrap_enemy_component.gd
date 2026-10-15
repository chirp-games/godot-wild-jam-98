extends PanelContainer

class_name ScrapEnemyComponent

@export var enemy: EnemyResource

@export var scrap_quantity = 0:
	set(v):
		scrap_quantity = v
		update_ui()
	get():
		return scrap_quantity
@export var amount_in_storage = 0:
	set(v):
		amount_in_storage = v
		update_ui()
	get():
		return amount_in_storage

@onready var units_in_storage_label: Label = %UnitsInStorage
@onready var enemy_name_lbael: Label = %EnemyName
@onready var unit_sell_amount: Label = %UnitSellAmount
@onready var scrap_amount_label: Label = %ScrapAmount
@onready var total_scrap_points: Label = %TotalScrapPoints

func _ready() -> void:
	update_ui()

func update_ui():
	if amount_in_storage == 0:
		hide()
	else:
		show()
	
	units_in_storage_label.text = str(amount_in_storage - scrap_quantity)
	enemy_name_lbael.text = str(enemy.name)
	unit_sell_amount.text = str(enemy.scrap_value) + "p"
	
	if scrap_quantity > 0:
		scrap_amount_label.text = str(scrap_quantity)
		total_scrap_points.text = str(get_total_points())
	else:
		scrap_amount_label.text = "-"
		total_scrap_points.text = ""

func get_total_points():
	return scrap_quantity * enemy.scrap_value

func _on_remove_quantity_pressed() -> void:
	if scrap_quantity > 0:
		scrap_quantity -= 1

func _on_add_quantity_pressed() -> void:
	if amount_in_storage > 0:
		scrap_quantity += 1
