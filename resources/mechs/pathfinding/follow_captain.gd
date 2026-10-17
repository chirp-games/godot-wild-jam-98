extends PathfindingResource

class_name PathfindingFollowCaptain

func pathfind(_game: Game, mech: FrogMech):
	if not mech.on_floor or mech.get_connected_commander() == null:
		return
	var direction: int = -sign(mech.global_position.x - mech.get_connected_commander().global_position.x)
	
	# for now, teleport to the player if too far
	if mech.global_position.distance_to(mech.get_connected_commander().global_position) > 500:
		mech.global_position = mech.get_connected_commander().global_position + Vector2(randi_range(-80, 80), 0)
		return
	
	mech.jump(direction)
