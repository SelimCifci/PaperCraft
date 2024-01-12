extends CharacterBody2D

@export var speed = 100.0
@export var crouch_speed = 60.0
@export var sprint_speed = 175.0
@export var sprint_jump_speed = 200.0
@export var jump_height = 150.0
@export var gravity = 500.0

var _velocity = Vector2.ZERO
var _direction = 0

@onready var _animation_player = $PlayerSprite/AnimationPlayer

func _physics_process(delta):
	movement(delta)
		
func movement(_delta):
	var _horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	var is_jumping = Input.is_action_pressed("jump") and is_on_floor()
	var is_idling = is_zero_approx(_horizontal_direction)
	var is_walking = not is_zero_approx(_horizontal_direction)
	var is_sprinting = is_walking and Input.is_action_pressed("sprint")
	var is_sneaking = Input.is_action_pressed("crouch") and is_on_floor() and is_walking
	
	# ---------------------------------------------------------------------------------
		
	_velocity.y += gravity * _delta
	
	var left_raycast = $RayCastLeft.is_colliding()
	var right_raycast = $RayCastRight.is_colliding()
	
	if is_sneaking:
		if left_raycast and right_raycast:
			_direction = 0
			_velocity.x = _horizontal_direction * crouch_speed
		elif left_raycast:
			_direction = 1
			_velocity.x = _horizontal_direction * crouch_speed
		elif right_raycast:
			_direction = -1
			_velocity.x = _horizontal_direction * crouch_speed
		else:
			if _direction == 1 and _horizontal_direction < 0:
				_velocity.x = _horizontal_direction * crouch_speed 
			elif _direction == -1 and _horizontal_direction > 0:
				_velocity.x = _horizontal_direction * crouch_speed 
			else:
				_velocity.x = 0.0
				
	elif is_walking and not is_sprinting:
		_velocity.x = _horizontal_direction * speed
	elif is_walking and is_sprinting and is_on_floor():
		_velocity.x = _horizontal_direction * sprint_speed
	elif is_walking and is_sprinting and not is_on_floor():
		_velocity.x = _horizontal_direction * sprint_jump_speed
	else:
		_velocity.x = 0.0
		
	if is_jumping:
		_velocity.y = -jump_height
	
	set_velocity(_velocity)
	move_and_slide()
	_velocity = velocity

	if is_sprinting:
		_animation_player.play("sprint")
	elif is_sneaking:
		_animation_player.play("sneak")
	elif is_walking:
		_animation_player.play("walk")
	elif is_idling:
		_animation_player.play("idle")
