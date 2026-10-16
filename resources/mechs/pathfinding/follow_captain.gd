extends PathfindingResource

class_name PathfindingFollowCaptain

func pathfind(_game: Game, mech: FrogMech):
	if not mech.on_floor or mech.get_connected_commander() == null:
		return
	var direction: int = -sign(mech.global_position.x - mech.get_connected_commander().global_position.x)
	mech.apply_central_impulse(Vector2(direction * 200., -200.))
