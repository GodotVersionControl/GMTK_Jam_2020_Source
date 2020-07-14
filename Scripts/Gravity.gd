extends KinematicBody2D


var gravity = 2500
var velocity = Vector2(0,1)

func get_direction():
	var lvelocity = velocity
	if get_parent().can_move:
		if Input.is_action_just_pressed("w") or Input.is_action_just_pressed("ui_up"):
			lvelocity = Vector2(0,-1)
		if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("ui_left"):
			lvelocity = Vector2(-1,0)
		if Input.is_action_just_pressed("s") or Input.is_action_just_pressed("ui_down"):
			lvelocity = Vector2(0,1)
		if Input.is_action_just_pressed("d") or Input.is_action_just_pressed("ui_right"):
			lvelocity = Vector2(1,0)
	return lvelocity.normalized()
	
func _physics_process(delta):
	velocity += get_direction() * gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func die():
	get_parent().game = false
	$CPUParticles2D.emitting = true
	$Body.visible = false
	$Head.visible = false
	get_parent().game_over()
	
