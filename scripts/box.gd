extends CharacterBody2D

func _physics_process(delta: float):
	velocity.y += Globals.GRAVITY * delta

	move_and_slide()

func _on_interaction_entered(area: Area2D):
	print(area)
