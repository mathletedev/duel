extends Node2D

@export var follow_id: int
@export var reload_time: float = 1

@onready var container: Node2D = $Container
@onready var firing_point: Node2D = $Container/FiringPoint
@onready var muzzle_flash: Node2D = $Container/FiringPoint/MuzzleFlash
@onready var muzzle_flash_timer: Timer = $MuzzleFlashTimer
@onready var player1: Node2D = %Player1
@onready var player2: Node2D = %Player2
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

const LERP_SPEED: float = 4

var follow: Node2D
var target: Node2D
var last_fired: int = -1000

func _ready():
	follow = player1 if follow_id == 1 else player2
	target = player2 if follow_id == 1 else player1

func _process(_delta):
	if Input.is_action_just_pressed("attack" + str(follow_id)) && Time.get_ticks_msec() > last_fired + reload_time * 1000:
		last_fired = Time.get_ticks_msec()

		var bullet: Node2D = bullet_scene.instantiate()
		bullet.global_transform = firing_point.global_transform
		get_tree().root.add_child(bullet)

		muzzle_flash.visible = true
		muzzle_flash_timer.start()

func _physics_process(delta: float):
	position += (follow.position - position) * LERP_SPEED * delta
	look_at(target.position)

	container.scale.y = -1 if rotation > PI / 2 && rotation < 3 * PI / 2 else 1

func _on_muzzle_flash_timer_timeout():
	muzzle_flash.visible = false
