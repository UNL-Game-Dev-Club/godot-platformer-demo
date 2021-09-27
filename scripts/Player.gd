extends KinematicBody2D


export var speed := 300.0
export var jump_speed := 800.0
export var gravity := 40.0
export var default_jumps_left := 1

var velocity := Vector2()
var on_ground := false
var jumps_left := default_jumps_left
var initial_position := position


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		respawn()
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$Sprite.flip_h = true
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("ui_up"):
		if on_ground:
			velocity.y = -jump_speed
		elif jumps_left:
			velocity.y = -jump_speed
			jumps_left -= 1
	
	var collision := move_and_collide(velocity * delta, true, true, true)
	if collision != null:
		jumps_left = default_jumps_left
		if move_and_collide(Vector2(0, 1), true, true, true) != null:
			on_ground = true
			velocity.y = 0
		else:
			on_ground = false
	else:
		on_ground = false
	
	velocity.y += gravity
	velocity = move_and_slide(velocity)


func respawn():
	position = initial_position
	velocity = Vector2()


func _on_RespawnArea_body_entered(body):
	if body == self:
		respawn()
