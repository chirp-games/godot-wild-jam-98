extends Node2D

const rat := preload("res://game/enemy/mothertruck/rat.tscn")
const signaler := preload("res://game/enemy/signaler/signaler.tscn")

var stock: Array[Enemy] = []
var wave_finished_spawning = false

signal spawn_enemy(e: PackedScene, near_enemy: Enemy)
signal wave_started
signal wave_ended

func start_wave():
	wave_finished_spawning = false
	wave_started.emit()
	for i in range(1):
		var e: Enemy = signaler.instantiate()
		spawn_enemy.emit(e, null)
		e.summon_reinforcements.connect(func(): await _summon_reinforcements(e))
		await get_tree().create_timer(2).timeout
	wave_finished_spawning = true

func _summon_reinforcements(around_enemy: Enemy):
	for i in range(5):
		spawn_enemy.emit(rat.instantiate(), around_enemy)
		await get_tree().create_timer(.1).timeout

func _process(_delta: float) -> void:
	if wave_finished_spawning and len(get_tree().get_nodes_in_group("enemy")) == 0:
		wave_ended.emit()
		wave_finished_spawning = false

func _on_start_wave_button_pressed() -> void:
	await start_wave()
