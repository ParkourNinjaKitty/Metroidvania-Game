extends KinematicBody2D

export var SPEED = 0
export var MAX_HEALTH = 0

var targeting_player = false
var sees_player = false
var attacking_player = false
var velocity = Vector2(0, 0)
var health = 0

onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	health = MAX_HEALTH

func _process(_delta):
	if health <= 0:
		death()
	
	if velocity.x > 0:
		$Sprite.flip_h = true
	if velocity.x < 0:
		$Sprite.flip_h = false
	
	animations()

func _physics_process(_delta):
	$PlayerTargetingRaycast.cast_to = player.global_position - global_position
	if targeting_player == true:
		$PlayerTargetingRaycast.enabled = true
		if $PlayerTargetingRaycast.is_colliding() == false:
			sees_player = true
			attacking_player = true
	if targeting_player == false:
		attacking_player = false
	
	if attacking_player == true:
		velocity = global_position.direction_to(player.global_position) * SPEED
	else:
		velocity = Vector2(0, 0)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func death():
	queue_free()

func _on_Hurtbox_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		health -= area.get_parent().damage
		$HurtAnimationPlayer.play("Hurt")

func animations():
	if attacking_player == false:
		$AnimationPlayer.play("Idle")
	if attacking_player == true:
		$AnimationPlayer.play("Fly")

func _on_PlayerDetectionArea_body_entered(body):
	if body.is_in_group("Player"):
		targeting_player = true

func _on_PlayerDetectionArea_body_exited(body):
	if body.is_in_group("Player"):
		targeting_player = false
