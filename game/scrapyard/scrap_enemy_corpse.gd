extends DragableRgidBody

class_name ScrapEnemyCorpse

signal on_click

func set_enemy(e: EnemyResource):
	$Texture.texture = e.texture
	$Texture.size = e.texture.get_size()
	$Texture.scale = e.texture_scale

func _on_right_click() -> void:
	on_click.emit()
