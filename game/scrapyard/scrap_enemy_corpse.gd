extends DragableRgidBody

class_name ScrapEnemyCorpse

signal on_click

var scrap_value = 0

func set_enemy(e: EnemyResource):
	$Texture.texture = e.texture
	$Texture.size = e.texture.get_size()
	$Texture.scale = e.texture_scale
	scrap_value = e.scrap_value

func _on_right_click() -> void:
	on_click.emit()
