extends KinematicBody2D

export var phase1_attack_cooldown = 0
export var phase2_attack_cooldown = 0
export var phase3_attack_cooldown = 0

export var phase1_transition_cooldown = 0
export var phase2_transition_cooldown = 0
export var phase3_transition_cooldown = 0

export var phase1_health = 0
export var phase2_health = 0
export var phase3_health = 0

var max_health = 0
var health = 0
var phase = phases.IDLE

var velocity = Vector2(0, 0)

enum phases {
	IDLE,
	PHASE1,
	PHASE2,
	PHASE3,
	DEAD
}

enum phase1 {
	SCEPTERSWING,
	CHASE
}

enum phase2 {
	SCEPTERTHROW,
	JUMP
}

enum phase3 {
	RATRAIN,
	DASH
}

func _ready():
	health = phase1_health + phase2_health + phase3_health
	max_health = phase1_health + phase2_health + phase3_health
	randomize()
	for i in PlayerStats.bosses_killed:
		if i == self.name.to_lower():
			$AnimationPlayer.play("AlreadyDead")

func _process(_delta):
	if max_health != 0:
		match phase:
			phases.PHASE1:
				if health <= max_health - phase1_health:
					phase = phases.PHASE2
					$Phase2Cooldown.start(phase2_transition_cooldown)
			phases.PHASE2:
				if health <= max_health - phase1_health - phase2_health:
					phase = phases.PHASE3
					$Phase3Cooldown.start(phase3_transition_cooldown)
			phases.PHASE3:
				if health <= max_health - phase1_health - phase2_health - phase3_health:
					phase = phases.DEAD
					death()
			phases.DEAD:
				velocity = Vector2(0, 0)

func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

#phases
func phase1_func():
	velocity = Vector2(0, 0)
	var next_attack = phase1.keys()[randi() % phase1.size()]
	var x_distance_to_player = global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x
	if abs(x_distance_to_player) < 36:
		next_attack = "SCEPTERSWING"
	if abs(x_distance_to_player) > 44:
		next_attack = "CHASE"
	if next_attack == "SCEPTERSWING":
		scepterswing()
	if next_attack == "CHASE":
		chase()
	$Phase1Cooldown.start(phase1_attack_cooldown)

func phase2_func():
	velocity = Vector2(0, 0)
	var next_attack = phase2.keys()[randi() % phase2.size()]
	if next_attack == "SCEPTERTHROW":
		scepterthrow()
	if next_attack == "JUMP":
		jump()
	$Phase2Cooldown.start(phase2_attack_cooldown)

func phase3_func():
	velocity = Vector2(0, 0)
	var next_attack = phase3.keys()[randi() % phase3.size()]
	if next_attack == "RATRAIN":
		ratrain()
	if next_attack == "DASH":
		dash()
	$Phase3Cooldown.start(phase3_attack_cooldown)

#phase 1 attacks
func scepterswing():
	$Scepter.swing()

func chase():
	$ChaseAttack.chase()

#phase 2 attacks
func scepterthrow():
	$Scepter.throw()

func jump():
	$AnimationPlayer.play("JumpTelegraph")

#phsae 3 attacks
func ratrain():
	$RatRainAttack.rat_rain()

func dash():
	if global_position.x - get_tree().get_nodes_in_group("Player")[0].global_position.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	$AnimationPlayer.play("DashTelegraph")

func spawn():
	get_tree().get_nodes_in_group("Player")[0].can_move = false
	$AnimationPlayer.play("Spawn")
	visible = true

func start_animation_over():
	get_tree().get_nodes_in_group("Player")[0].can_move = true
	$Hitbox/CollisionShape2D.disabled = false
	$Hurtbox/CollisionShape2D.disabled = false
	$Scepter/Hitbox/CollisionShape2D.disabled = false
	phase = phases.PHASE1
	$Phase1Cooldown.start(phase1_transition_cooldown)

func death():
	get_tree().get_nodes_in_group("BossroomDoor")[0].open_bossroom_doors()
	PlayerStats.bosses_killed.append("ratking")
	
	SaveManager.save_file()
	
	$AnimationPlayer.play("Death")
	
	$Hitbox/CollisionShape2D.disabled = true
	$Hurtbox/CollisionShape2D.disabled = true
	$Scepter/Hitbox/CollisionShape2D.disabled = true

func _on_Phase1Cooldown_timeout():
	if phase == phases.PHASE1:
		phase1_func()

func _on_Phase2Cooldown_timeout():
	if phase == phases.PHASE2:
		phase2_func()

func _on_Phase3Cooldown_timeout():
	if phase == phases.PHASE3:
		phase3_func()

func _on_Hurtbox_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		health -= area.get_parent().damage
		$HurtAnimationPlayer.play("Hurt")
