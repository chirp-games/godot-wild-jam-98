extends DragableRgidBody

class_name ScrapEnemyCorpse

signal on_click

func set_enemy(e: EnemyResource):
	$Sprite2D.texture = e.texture
	$Sprite2D.scale = e.texture_scale * .5


func _on_right_click() -> void:
	on_click.emit()
