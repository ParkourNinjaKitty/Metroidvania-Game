extends KinematicBody2D

class_name PlatformerController2D

# Set these to the name of your action (in the Input Map)
export var input_left : String = "left"
export var input_right : String = "right"
export var input_up : String = "up"
export var input_down : String = "down"
export var input_jump : String = "jump"
export var input_attack : String = "attack"
export var input_dash : String = "dash"

# The max jump height in pixels (holding jump)
export var max_jump_height = 26 setget set_max_jump_height
# The minimum jump height (tapping jump)
export var min_jump_height = 8 setget set_min_jump_height
# The height of your jump in the air
export var double_jump_height = 16 setget set_double_jump_height
# How long it takes to get to the peak of the jump in seconds
export var jump_duration = 0.3 setget set_jump_duration
# Multiplies the gravity by this while falling
export var falling_gravity_multiplier = 1.5
# Set to 2 for double jump
export var max_jump_amount = 1
export var max_acceleration = 1500
export var friction = 32
export var can_hold_jump : bool = false
# You can still jump this many seconds after falling off a ledge
export var coyote_time : float = 0.1
# Only neccessary when can_hold_jump is off
# Pressing jump this many seconds before hitting the ground will still make you jump
export var jump_buffer : float = 0.1
export var dash_speed = 1300
export var dash_time = 0.125
export var dash_cooldown = 0.75
export var attack_cooldown = 0.5

export var vertical_knockback_force = 96
export var horizontal_knockback_force = 256

export var damage_taken_knockback = 128

export var damage = 1

# not used
var max_speed = 100
var acceleration_time = 10


# These will be calcualted automatically
var default_gravity : float
var jump_velocity : float
var double_jump_velocity : float
# Multiplies the gravity by this when we release jump
var release_gravity_multiplier : float


var jumps_left : int
var holding_jump := false

var vel = Vector2()
var acc = Vector2()
var direction = 1
var dash_direction = 1
var last_ground_pos = Vector2()

var isdashing = false
var candash = true
var dash_unlocked = false
var double_jump_unlocked = false
var can_attack = true
var can_take_damage = true
var can_move = true

var max_health = 5
var health = 5
var invulnerablility_time = 0.5

onready var coyote_timer = Timer.new()
onready var jump_buffer_timer = Timer.new()
onready var invulnerability_timer = $Invulnerability_timer
onready var dash_timer = $Dash_timer
onready var dash_cooldown_timer = $Dash_cooldown_timer
onready var attack_cooldown_timer = $Attack_cooldown_timer


func _init():
	default_gravity = calculate_gravity(max_jump_height, jump_duration)
	jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
	release_gravity_multiplier = calculate_release_gravity_multiplier(
		jump_velocity, min_jump_height, default_gravity)


func _ready():
	add_child(coyote_timer)
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	
	add_child(jump_buffer_timer)
	jump_buffer_timer.wait_time = jump_buffer
	jump_buffer_timer.one_shot = true
	
	dash_timer.wait_time = dash_time
	dash_timer.one_shot = true
	
	dash_cooldown_timer.wait_time = dash_cooldown
	dash_cooldown_timer.one_shot = true
	
	$UI/Health.visible = true
	spawn()
	set_stats()


func _process(_delta):
	if can_move == true:
		if vel == null:
			vel = Vector2(0, 0)
		animations()
		
		$UI/Health.rect_size.x = health * 10
		
		if health <= 0:
			death()


func _physics_process(delta):
	if can_move == true:
		if vel == null:
			vel = Vector2(0, 0)
		acc.x = 0
		
		set_last_ground_pos()
		
		if is_on_floor():
			coyote_timer.start()
		if not coyote_timer.is_stopped():
			jumps_left = max_jump_amount
		
		if Input.is_action_pressed(input_dash):
			if dash_unlocked == true:
				if candash == true:
					dash()
		
		if isdashing == false:
			direction = int(Input.is_action_pressed(input_right)) - int(Input.is_action_pressed(input_left))
			if direction != 0:
				dash_direction = direction
			acc.x = direction * max_acceleration
			PlayerStats.direction = dash_direction
		
		
		if isdashing == false:
			# Check for ground jumps when we can hold jump
			if can_hold_jump:
				if Input.is_action_pressed(input_jump):
					# Dont use double jump when holding down
					if is_on_floor():
						jump()
			
			# Check for ground jumps when we cannot hold jump
			if not can_hold_jump:
				if not jump_buffer_timer.is_stopped() and is_on_floor():
					jump()
			
			# Check for jumps in the air
			if Input.is_action_just_pressed(input_jump):
				holding_jump = true
				jump_buffer_timer.start()
				
				# Only jump in the air when press the button down, code above already jumps when we are grounded
				if not is_on_floor():
					jump()
				
			
			if Input.is_action_just_released(input_jump):
				holding_jump = false
			
			
		var gravity = default_gravity
		
		if vel.y > 0: # If we are falling
			gravity *= falling_gravity_multiplier
				
		if not holding_jump and vel.y < 0: # if we released jump and are still rising
			if not jumps_left < max_jump_amount - 1: # Always jump to max height when we are using a double jump
				gravity *= release_gravity_multiplier # multiply the gravity so we have a lower jump
	
		if isdashing == false:
			acc.y = -gravity
		if isdashing == true:
			acc.y = 0
		
		vel.x *= 1 / (1 + (delta * friction))
		
		vel += acc * delta
		vel = move_and_slide(vel, Vector2.UP)
		
		if Input.is_action_just_pressed("attack"):
			if can_attack == true:
				attack_input()


func dash() -> void:
	candash = false
	if isdashing == false:
		dash_timer.start()
	vel = Vector2(dash_direction, 0)
	vel *= dash_speed
	isdashing = true
	PlayerStats.direction = dash_direction


func _on_Invuelnerability_timer_timeout():
	can_take_damage = true


func _on_Dash_timer_timeout():
	isdashing = false
	dash_cooldown_timer.start()

func _on_Dash_cooldown_timer_timeout():
	candash = true


func _on_Attack_cooldown_timeout():
	can_attack = true
	$Sprite/Light2D.enabled = true


func _on_Hurtbox_area_entered(area):
	if can_move == true:
		if can_take_damage == true:
			can_take_damage = false
			invulnerability_timer.start(invulnerablility_time)
			health -= area.damage
			if area.is_in_group("Obstacle"):
				obstacle_death()
				return
			vel = (area.global_position - global_position).normalized() * -damage_taken_knockback
			$HitAnimationPlayer.play("Hit")


func calculate_gravity(p_max_jump_height, p_jump_duration):
	# Calculates the desired gravity by looking at our jump height and jump duration
	# Formula is from this video https://www.youtube.com/watch?v=hG9SzQxaCm8
	return (-2 *p_max_jump_height) / pow(p_jump_duration, 2)


func calculate_jump_velocity(p_max_jump_height, p_jump_duration):
	# Calculates the desired jump velocity by lookihg at our jump height and jump duration
	return (2 * p_max_jump_height) / (p_jump_duration)


func calculate_jump_velocity2(p_max_jump_height, p_gravity):
	# Calculates jump velocity from jump height and gravity
	# formula from 
	# https://sciencing.com/acceleration-velocity-distance-7779124.html#:~:text=in%20every%20step.-,Starting%20from%3A,-v%5E2%3Du
	return sqrt(-2 * p_gravity * p_max_jump_height)


func calculate_release_gravity_multiplier(p_jump_velocity, p_min_jump_height, p_gravity):
	# Calculates the gravity when the key is released based on the minimum jump height and jump velocity
	# Formula is from this website https://sciencing.com/acceleration-velocity-distance-7779124.html
	var release_gravity = 0 - pow(p_jump_velocity, 2) / (2 * p_min_jump_height)
	return release_gravity / p_gravity


func calculate_friction(time_to_max):
	# Formula from https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3
	# this friction will hit 90% of max speed after the accel time
	return 1 - (2.30259 / time_to_max)


func calculate_speed(p_max_speed, p_friction):
	# Formula from https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3	
	return (p_max_speed / p_friction) - p_max_speed


func jump():
	if can_move == true:
		if jumps_left == max_jump_amount and coyote_timer.is_stopped():
			# Your first jump must be used when on the ground
			# If you fall off the ground and then jump you will be using you second jump
			jumps_left -= 1
			
		if jumps_left > 0:
			if jumps_left < max_jump_amount: # If we are double jumping
				vel.y = -double_jump_velocity
			else:
				vel.y = -jump_velocity
			jumps_left -= 1
		
		
		coyote_timer.stop()


func animations():
	if can_move == true:
		if Input.is_action_pressed(input_left):
			$Sprite.scale.x = -1
		if Input.is_action_pressed(input_right):
			$Sprite.scale.x = 1
		if isdashing == true:
			$AnimationPlayer.play("Dash")
		elif vel.y < 0:
			if $AnimationPlayer.current_animation != "Jump":
				$AnimationPlayer.play("Jump")
		elif vel.y > 0:
			if $AnimationPlayer.current_animation != "Fall":
				$AnimationPlayer.play("Fall")
		elif vel.x < -0.1 or vel.x > 0.1:
			$AnimationPlayer.play("Run")
		else:
			$AnimationPlayer.play("Idle")


func update_player_stats():
	PlayerStats.max_health = max_health
	PlayerStats.health = health
	PlayerStats.direction = direction
	PlayerStats.dash_unlocked = dash_unlocked
	PlayerStats.double_jump_unlocked = double_jump_unlocked


func spawn():
	if PlayerStats.enter_direction_key != null:
		for i in get_tree().get_nodes_in_group("Level_Spawner"):
			if i.enter_direction_key == PlayerStats.enter_direction_key:
				direction = PlayerStats.direction
				global_position = i.global_position
				dash_direction = direction
				$Sprite.scale.x = direction
				acc = Vector2(0, 0)
				vel = i.spawn_velocity


func attack_input():
	if can_move == true:
		if Input.is_action_pressed(input_up):
			attack("Up", Vector2(0, 1))
		elif Input.is_action_pressed(input_down):
			attack("Down", Vector2(0, -1))
		else:
			if dash_direction == -1:
				attack("Left", Vector2(1, 0))
			if dash_direction == 1:
				attack("Right", Vector2(-1, 0))


func attack(attack_direction, knockback_force):
	if can_move == true:
		$AttackAnimationPlayer.play(attack_direction)
		vel.y = knockback_force.y*vertical_knockback_force
		vel.x = knockback_force.x*horizontal_knockback_force
		start_attack_cooldown()
		$Sprite/Light2D.enabled = false


func set_last_ground_pos():
	for i in $GroundRaycasts.get_children():
		if not i.is_colliding():
			return
	last_ground_pos = global_position


func obstacle_death():
	can_move = false
	global_position = last_ground_pos
	vel = Vector2(0, 0)
	$AnimationPlayer.play("ObstacleDeath")


func obstacle_death_animation_over():
	can_move = true


func death():
	can_move = false
	$UI/Health.rect_scale.x = 0
	$AnimationPlayer.play("Death")


func death_animation_over():
# warning-ignore:return_value_discarded
	get_tree().change_scene(str(PlayerStats.last_level_save))
	PlayerStats.enter_direction_key = PlayerStats.last_save_spawn_key


func start_attack_cooldown():
	can_attack = false
	attack_cooldown_timer.start(attack_cooldown)


func set_stats():
	max_health = PlayerStats.max_health
	health = PlayerStats.health
	direction = PlayerStats.direction
	dash_unlocked = PlayerStats.dash_unlocked
	double_jump_unlocked = PlayerStats.double_jump_unlocked


func set_max_jump_height(value):
	max_jump_height = value
	
	default_gravity = calculate_gravity(max_jump_height, jump_duration)
	jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
	release_gravity_multiplier = calculate_release_gravity_multiplier(
		jump_velocity, min_jump_height, default_gravity)


func set_jump_duration(value):
	jump_duration = value
	
	default_gravity = calculate_gravity(max_jump_height, jump_duration)
	jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
	release_gravity_multiplier = calculate_release_gravity_multiplier(
		jump_velocity, min_jump_height, default_gravity)


func set_min_jump_height(value):
	min_jump_height = value
	release_gravity_multiplier = calculate_release_gravity_multiplier(
		jump_velocity, min_jump_height, default_gravity)


func set_double_jump_height(value):
	double_jump_height = value
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
