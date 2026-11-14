extends CharacterBody2D


const FORWARD_SPEED = 200.0
const FORWARD_FRICTION = .002

const ROTATIONAL_SPEED = 30
const ROTATIONAL_FRICTION = .2

var speed = 0
var forward_velocity = Vector2.ZERO
var rotational_velocity = 0





func movement(direction_input, thrust_input, delta):
	rotational_velocity += direction_input * ROTATIONAL_SPEED * delta
	rotational_velocity = lerpf(rotational_velocity, 0, ROTATIONAL_FRICTION)
	rotation += rotational_velocity * delta
	
	forward_velocity += Vector2.RIGHT.rotated(rotation) * thrust_input * FORWARD_SPEED * delta
	forward_velocity = Vector2.RIGHT.rotated(rotation) * forward_velocity.length()
	forward_velocity = lerp(forward_velocity, Vector2.ZERO, FORWARD_FRICTION)
	position += forward_velocity * delta
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	var direction_input := Input.get_axis("left", "right")
	var thrust_input = Input.get_axis("backward", "forward")
	movement(direction_input, thrust_input, delta)
	
	#var grapple_input = Input.action_press("grapple")
