extends KinematicBody2D

export var SPEED = 0
export (float) var GRAVITY = 0
export var MAX_HEALTH = 0

var velocity = Vector2(0, 0)
var direction = 1
var health = 0

func _ready():
	health = MAX_HEALTH

func _process(_delta):
	if health <= 0:
		death()
	
	if direction == 1:
		$Sprite.flip_h = true
	if direction == -1:
		$Sprite.flip_h = false

func _physics_process(_delta):
	_should_turn()
	
	if is_on_floor():
		velocity.x = direction * SPEED
		velocity.y = 0
	else:
		velocity.x = 0
		velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _should_turn():
	if direction == -1:
		if $WallRaycasts/Left.is_colliding():
			direction = 1
		if not $EdgeRaycasts/Left.is_colliding():
			direction = 1
	if direction == 1:
		if $WallRaycasts/Right.is_colliding():
			direction = -1
		if not $EdgeRaycasts/Right.is_colliding():
			direction = -1

func death():
	queue_free()

func _on_Hurtbox_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		health -= area.get_parent().damage
		$HurtAnimationPlayer.play("Hurt")

func animations():
	if $AnimationPlayer.current_animation == "Spawn" or $AnimationPlayer.current_animation == "Idle" or $AnimationPlayer.current_animation == "Walk":
		if velocity.x == 0:
			$AnimationPlayer.play("Idle")
		else:
			$AnimationPlayer.play("Walk")
