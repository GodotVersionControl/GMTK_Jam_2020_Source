extends KinematicBody2D

var speed = 220
var jump_speed = -650
var gravity = 2500

var imune = false
var fliped = false
var p_name = "idk"

var up = "ui_page_up"
var left = "ui_page_up"
var right = "ui_page_up"

var velocity = Vector2.ZERO
var time_jump = true
var jumped = false

func _ready():
	$Body.playing = true
	
func flip():
	fliped = !fliped
	if p_name == "Boy":
		if fliped:
			$CollisionShape2D.position.y = -3
		else:
			$CollisionShape2D.position.y = 3
	else:
		if fliped:
			$CollisionShape2D.position.y = -1
		else:
			$CollisionShape2D.position.y = 1
			
	$Head.flip_v = !$Head.flip_v 
	$Body.flip_v = !$Body.flip_v
	gravity = -gravity
	jump_speed = -jump_speed

func get_input():
	velocity.x = 0
	if Input.is_action_pressed(right):
		velocity.x += speed
		$Body.flip_h = true
		$Head.flip_h = true
		$CollisionShape2D.position.x = 1
		if $Body.animation != "Run":
			$Body.animation = "Run"
	if Input.is_action_pressed(left):
		$Body.flip_h = false
		$Head.flip_h = false
		$CollisionShape2D.position.x = -2
		if $Body.animation != "Run":
			$Body.animation = "Run"
		velocity.x -= speed

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if velocity.y >= 2500:
		velocity.y = 2500
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor() and not fliped:
		if velocity.x == 0:
			$Body.animation = "Idle"
		jumped = false
		if not $Timer.is_stopped():
			$Timer.stop()
	elif is_on_ceiling() and fliped:
		if velocity.x == 0:
			$Body.animation = "Idle"
		jumped = false
		if not $Timer.is_stopped():
			$Timer.stop()
	else:
		$Body.animation = "Jump"
		time_jump = true
		$Timer.start()
	if Input.is_action_just_pressed(up):
		if not fliped:
			if (is_on_floor() or time_jump) and not jumped:
				velocity.y = jump_speed
				jumped = true
		elif fliped:
			if (is_on_floor() or time_jump) and not jumped:
				velocity.y = jump_speed
				jumped = true


func _on_Timer_timeout():
	time_jump = false


func die():
	if not imune:
		$CPUParticles2D.emitting = true
		$Body.visible = false
		$Head.visible = false
		up = "ui_page_up"
		left = "ui_page_up"
		right = "ui_page_up"
		get_parent().game_over()
