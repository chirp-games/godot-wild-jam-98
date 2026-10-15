extends Node2D

const default_enemy := preload("res://game/enemy/mothertruck/mothertruck.tscn")

var wave_finished_spawning = false

signal spawn_enemy(e: PackedScene)
signal wave_started
signal wave_ended

func start_wave():
	wave_finished_spawning = false
	wave_started.emit()
	for i in range(5):
		spawn_enemy.emit(default_enemy)
		await get_tree().create_timer(2).timeout
	wave_finished_spawning = true

func _process(_delta: float) -> void:
	if wave_finished_spawning and len(get_tree().get_nodes_in_group("enemy")) == 0:
		wave_ended.emit()
		wave_finished_spawning = false

func _on_start_wave_button_pressed() -> void:
	await start_wave()
