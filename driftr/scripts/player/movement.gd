extends CharacterBody2D


const FORWARD_SPEED = 1000.0
const FORWARD_FRICTION = .01

const ROTATIONAL_SPEED = 30
const ROTATIONAL_FRICTION = .2


const GRAPPLE_DISTANCE = 600
const GRAPPLE_DISTANCE_SQUARED = GRAPPLE_DISTANCE ** 2
const GRAPPLE_STRENGTH = 3



var speed = 0
var forward_velocity = Vector2.ZERO
var rotational_velocity = 0
var velocity_direction = Vector2.RIGHT

var grapple_press = false
var grapple_release = false
var current_grapple_point = 0
var currently_grappling = false

var angle = 0

var steer = false


func get_rotation_vector(radians):
	return Vector2(cos(radians), sin(radians))

func get_radians(vector):
	return Vector2.RIGHT.angle_to(vector)

func movement(delta):
	var direction_input = Input.get_axis("left", "right")
	rotational_velocity += direction_input * ROTATIONAL_SPEED * delta
	rotational_velocity = lerpf(rotational_velocity, 0, ROTATIONAL_FRICTION)
	rotation += rotational_velocity * delta
	
	
	var thrust_input = Input.get_axis("backward", "forward")
	forward_velocity += get_rotation_vector(rotation) * thrust_input * FORWARD_SPEED * delta
	if steer:
		forward_velocity = velocity_direction * forward_velocity.length()
		print(velocity_direction)
	
	#position += forward_velocity * delta
	
	forward_velocity = lerp(forward_velocity, Vector2.ZERO, FORWARD_FRICTION)
	var collision = move_and_collide(forward_velocity * delta)
	if collision:
		forward_velocity = Vector2.ZERO

func grapple(delta):
	if Input.is_action_just_pressed("grapple"):
		grapple_press = true
	else:
		grapple_press = false
		
	if Input.is_action_just_released("grapple"):
		grapple_release = true
		currently_grappling = false
	else:
		grapple_release = false
		
	
	if grapple_press:
		var distance_to_grapple_point = INF
		currently_grappling = false
		for node in get_parent().get_node("GrapplePoints").get_children():
			var new_distance = position.distance_squared_to(node.position)
			if new_distance < distance_to_grapple_point and new_distance < GRAPPLE_DISTANCE_SQUARED:
				distance_to_grapple_point = new_distance
				current_grapple_point = node
				currently_grappling = true
	
	if current_grapple_point:
		var distance_squared = position.distance_squared_to(current_grapple_point.position)
		if distance_squared > GRAPPLE_DISTANCE_SQUARED:
			currently_grappling = false
		elif distance_squared < 15000:
			currently_grappling = false
			
		
	if currently_grappling:
		var player_to_grapple_point = current_grapple_point.position - position
		if 0:
			var angle_to_up = player_to_grapple_point.angle_to(Vector2.UP)
			var rotated_player_rotation = get_rotation_vector(rotation).rotated(angle_to_up)
			rotated_player_rotation.x *= -1
			
			if rotated_player_rotation.x < 0:
				angle = PI/2
			elif rotated_player_rotation.x > 0:
				angle = -PI/2
			elif rotated_player_rotation == 0:
				pass
			rotation = Vector2.RIGHT.angle_to(player_to_grapple_point.rotated(angle).normalized())
		else:
			forward_velocity += player_to_grapple_point * delta * GRAPPLE_STRENGTH
			rotation = get_radians(player_to_grapple_point)
	
	else:
		current_grapple_point = 0
		


func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("steer"):
		velocity_direction = forward_velocity.normalized()
	if Input.get_action_strength("steer"):
		steer = true
		velocity_direction = lerp(velocity_direction, get_rotation_vector(rotation), .1)
	else:
		steer = false
		
	movement(delta)
	grapple(delta)
	
	#var grapple_input = Input.action_press("grapple")
