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

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("left", "right")
	if direction:
		for joint in [fs,fk,fa,ba,bk,bs,hp,hd]:
			joint.motor_enabled = true
		hp.motor_target_velocity = 320
		bk.motor_target_velocity = -440
		bs.motor_target_velocity = 160
		ba.motor_target_velocity = 40
	else:
		for joint in [fs,fk,fa,ba,bk,bs,hp,hd]:
			joint.motor_enabled = true
		for joint in []:
			joint.motor_enabled = false
		hp.motor_target_velocity = 80
		bk.motor_target_velocity = -110
		bs.motor_target_velocity = 40
		ba.motor_target_velocity = 3
		fk.motor_target_velocity = -50
		fs.motor_target_velocity = 40
		fa.motor_target_velocity = 50
		hd.motor_target_velocity = -22
	print(($Spine/Hip as PhysicalBone2D).rotation)

func set_sprite_visibility(are_visible: bool) -> void:
	for i in get_bone_count():
		for child in get_bone(i).get_children():
			if child is Sprite2D:
				(child as Sprite2D).visible = are_visible
				
@export_tool_button("Hide sprites")
var hide_sprites = func(): set_sprite_visibility(false)
@export_tool_button("Show sprites")
var show_sprites = func(): set_sprite_visibility(true)
