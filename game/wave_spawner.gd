extends Node2D

enum Spawns {
	L1,
	L2,
	L3,
	R1,
	R2,
	R3,
}

const signaler := preload("res://game/enemy/signaler/signaler.tscn")
const gunbot := preload("res://game/enemy/gunbot/gunbot.tscn")
const kddv := preload("res://game/enemy/mothertruck/mothertruck.tscn")
const shahed := preload("res://game/enemy/shahed/shahed.tscn")
const icbm := preload("res://game/enemy/icbm/icbm.tscn")

const spawns = [
	Spawns.L1,
	Spawns.L2,
	Spawns.L3,
	Spawns.R1,
	Spawns.R2,
	Spawns.R3,
]
const early_spawns = [
	Spawns.L1,
	Spawns.R1,
]
const midgame_spawns = [
	Spawns.L1,
	Spawns.R1,
	Spawns.L2,
	Spawns.R2
]

var valid_enemies: Dictionary = {
	shahed: 1
}

var wave: int = 0
var signal_cd: float = 30.
var stock: Array[Enemy] = []

signal spawn_enemy(e: PackedScene, near_enemy: Enemy)

func start_wave():
	signal_cd = 30
	var spot: Spawns
	if wave < 4:
		spot = early_spawns.pick_random()
	elif wave < 12:
		spot = midgame_spawns.pick_random()
	else:
		spot = spawns.pick_random()
		
	for i in range(1):
		var e: Enemy = signaler.instantiate()
		spawn_enemy.emit(e, null, spot)
		e.summon_reinforcements.connect(func(): await _summon_reinforcements(e, spot))
		await get_tree().create_timer(2).timeout

func _summon_reinforcements(around_enemy: Enemy, location: Spawns):
	wave += 1
	for i in range(5):
		spawn_enemy.emit(valid_enemies[location].pick_random().instantiate(), around_enemy)
		await get_tree().create_timer(.3).timeout
	while len(stock) > 0:
		spawn_enemy.emit(stock.pop_front().instantiate(), around_enemy)
		await get_tree().create_timer(.3).timeout

func _process(delta: float) -> void:
	signal_cd += delta
	if signal_cd <= 0:
		await start_wave()

func _on_start_wave_button_pressed() -> void:
	await start_wave()


func _on_retreat(body: Node2D) -> void:
	if body is KDDV:
		stock.push_back(kddv)
		body.queue_free()
