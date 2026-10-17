extends PathfindingResource

class_name PathfindingFollowPlayer

func pathfind(game: Game, mech: FrogMech):
	if not mech.on_floor:
		return
	var direction: int = sign(game.player.global_position.x - mech.global_position.x)
	
	if mech.global_position.distance_to(game.player.global_position) > 900:
		mech.global_position = game.player.global_position
		return
	
	
	mech.jump(direction)
