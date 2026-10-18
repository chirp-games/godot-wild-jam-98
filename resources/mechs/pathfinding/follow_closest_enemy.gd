extends PathfindingResource

class_name PathfindingFollowClosestEnemy

func pathfind(_game: Game, mech: FrogMech):
	if not mech.on_floor:
		return
	
	
	var enemies = mech.get_tree().get_nodes_in_group("enemy")
	if len(enemies) == 0:
		return
	enemies.sort_custom(func(x, y): return x.global_position.distance_to(mech.global_position) < y.global_position.distance_to(mech.global_position))
	
	var closest_enemy = enemies[0]
	var direction: int = -sign(mech.global_position.x - closest_enemy.global_position.x)

	mech.jump(direction)
