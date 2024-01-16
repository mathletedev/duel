extends CharacterBody2D

@export var id: int
@export var speed: float = 1000
@export var friction: float = 0.9
@export var jump_force: float = 200
@export var jump_gravity: float = 600
@export var hold_gravity: float = 300
@export var fall_gravity: float = 1000
@export var coyote_time: float = 0.1
@export var jump_buffer: float = 0.1

@onready var anim := $AnimatedSprite2D

const ANIM_DEADZONE: Vector2 = Vector2(10, 100)

var input: float
var last_floor: int = 0
var last_jump: int = -1000

func _physics_process(delta: float):
	input = Input.get_axis("left" + str(id), "right" + str(id))
	velocity.x += input * speed * delta
	velocity.x *= friction

	var gravity: float
	if velocity.y < 0:
		if Input.is_action_pressed("jump" + str(id)):
			gravity = hold_gravity
		else:
			gravity = jump_gravity
	else:
		gravity = fall_gravity
	
	var curr_time := Time.get_ticks_msec()

	if is_on_floor():
		last_floor = curr_time
	if Input.is_action_just_pressed("jump" + str(id)):
		last_jump = curr_time

	if curr_time - last_jump < jump_buffer * 1000 && curr_time - last_floor < coyote_time * 1000:
		velocity.y = -jump_force
		last_jump = 0
	else:
		velocity.y += gravity * delta

	move_and_slide()
	animate()

func animate() -> void:
	if velocity.x > 0 && anim.flip_h:
		anim.flip_h = false
	elif velocity.x < 0 && !anim.flip_h:
		anim.flip_h = true

	if is_on_floor():
		anim.animation = "run" if input else "idle"
		return

	if velocity.y < -ANIM_DEADZONE.y:
		anim.animation = "up"
	elif velocity.y > ANIM_DEADZONE.y:
		anim.animation = "down"
	else:
		anim.animation = "float"
