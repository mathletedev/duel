extends Area2D

@export var speed: float = 400
@export var lifetime: float = 1

var start_time: int

func _ready():
	start_time = Time.get_ticks_msec()

func _process(delta: float):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

	if Time.get_ticks_msec() > start_time + lifetime * 1000:
		queue_free()
