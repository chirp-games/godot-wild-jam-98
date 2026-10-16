extends PathfindingResource

class_name PathfindingStandStill

func pathfind(_game: Game, mech: FrogMech):
	mech.apply_central_impulse(Vector2(0, -200.))
