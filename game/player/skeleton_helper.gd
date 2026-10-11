@tool
extends Skeleton2D

@onready var fs: PinJoint2D = %FrontShoulder
@onready var fk: PinJoint2D = %FrontKnee
@onready var fa: PinJoint2D = %FrontAnkle
@onready var ba: PinJoint2D = %BackAnkle
@onready var bk: PinJoint2D = %BackKnee
@onready var bs: PinJoint2D = %BackShoulder
@onready var hp: PinJoint2D = %Hip
@onready var hd: PinJoint2D = %Head
@onready var fam: Marker2D = %FAM

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("ui_left", "ui_right")
	#print(($Spine/Hip as PhysicalBone2D).rotation)
	if direction:
		fam.position.x += direction

func set_sprite_visibility(are_visible: bool) -> void:
	for i in get_bone_count():
		for child in get_bone(i).get_children():
			if child is Sprite2D:
				(child as Sprite2D).visible = are_visible
				
@export_tool_button("Hide sprites")
var hide_sprites = func(): set_sprite_visibility(false)
@export_tool_button("Show sprites")
var show_sprites = func(): set_sprite_visibility(true)
