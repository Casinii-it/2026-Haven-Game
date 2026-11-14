extends CharacterBody2D


const SPEED = 300.0


const ROTATIONAL_SPEED = 1
const ROTATIONAL_FRICTION = .2

var rotational_velocity = 0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	rotational_velocity += direction * ROTATIONAL_SPEED * delta
	rotational_velocity = lerpf(rotational_velocity, 0, ROTATIONAL_FRICTION)
	rotation += rotational_velocity * delta
	
	move_and_slide()
