extends Node

const GRAVITY: float = 1000

func other_id(id: int) -> int:
	return int(!(id - 1)) + 1
