extends Node2D

func _ready() -> void:
	Vfx.reparent.call_deferred(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$Sprite2D.rotation = 0.05
