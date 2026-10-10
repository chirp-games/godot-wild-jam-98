@tool
extends Skeleton2D


func set_sprite_visibility(are_visible: bool) -> void:
	for i in get_bone_count():
		for child in get_bone(i).get_children():
			if child is Sprite2D:
				(child as Sprite2D).visible = are_visible
				
@export_tool_button("Hide sprites")
var hide_sprites = func(): set_sprite_visibility(false)
@export_tool_button("Show sprites")
var show_sprites = func(): set_sprite_visibility(true)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var stack = get_modification_stack()
	var physical_bones = stack.get_modification(0) as SkeletonModification2DPhysicalBones

	print("Simulation started")
	physical_bones.start_simulation()
