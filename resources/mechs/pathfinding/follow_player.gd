extends PathfindingResource

class_name PathfindingFollowPlayer

func pathfind(game: Game, mech: FrogMech):
	if not mech.on_floor:
		return
	var direction: int = sign(game.player.global_position.x - mech.global_position.x)
	mech.apply_central_impulse(Vector2(direction * 200., -200.))
