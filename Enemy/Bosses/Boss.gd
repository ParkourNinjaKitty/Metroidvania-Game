extends KinematicBody2D

export var phase1_attack_cooldown = 0
export var phase2_attack_cooldown = 0
export var phase3_attack_cooldown = 0

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
			phases.PHASE2:
				if health <= max_health - phase1_health - phase2_health:
					phase = phases.PHASE3
			phases.PHASE3:
				if health <= max_health - phase1_health - phase2_health - phase3_health:
					phase = phases.DEAD
					death()
			phases.DEAD:
				velocity = Vector2(0, 0)

func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func death():
	get_tree().get_nodes_in_group("BossroomDoor")[0].open_bossroom_doors()
	PlayerStats.bosses_killed.append(str(self.name.to_lower()))
	
	SaveManager.save_file()
	
	$AnimationPlayer.play("Death")

func spawn():
	get_tree().get_nodes_in_group("Player")[0].can_move = false
	$AnimationPlayer.play("Spawn")
	visible = true

func start_animation_over():
	get_tree().get_nodes_in_group("Player")[0].can_move = true
	phase = phases.PHASE1
	$PhaseTransitions.play("Phase1")

func _on_Hurtbox_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		health -= area.get_parent().damage
		$HurtAnimationPlayer.play("Hurt")
