extends CharacterBody3D


@export var move_speed = 5.0
@export var jump_velocity = 4.5
@export var gravity = 9.8
@export var camera_turn_speed = 0.2
@export var max_jumps = 1

var respawn_point: Vector3

var _direction
var _jumps = 1

@onready var camera_base = $CameraBase
@onready var animation = $Character/AnimationPlayer
		
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	respawn_point = global_position

func _process(delta):
	_update_animations()

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	_vertical_movement(delta)
	_horizontal_movement(delta)
	
	move_and_slide()

func die():
	animation.play("locomotion-library/death")
	set_process(false)
	set_physics_process(false)
	
func respawn():
	set_process(true)
	set_physics_process(true)
	global_position = respawn_point

func _input(event):
	if event is InputEventMouseMotion:
		camera_base.rotation.x -= deg_to_rad(event.relative.y * camera_turn_speed)
		camera_base.rotation.x = clamp(camera_base.rotation.x, deg_to_rad(-45), deg_to_rad(45))
		rotation.y -= deg_to_rad(event.relative.x * camera_turn_speed)

func _update_animations():
	if is_on_floor():
		if _direction:
			animation.play("locomotion-library/run")
		else:
			animation.play("locomotion-library/idle")
	elif _jumps == max_jumps:
		animation.play("locomotion-library/falling")
		
func _gravity(delta):
	if is_on_floor():
		_jumps = max_jumps
	velocity.y -= gravity * delta
	
func _horizontal_movement(delta):
	if _direction:
		velocity.x = _direction.x * move_speed
		velocity.z = _direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)	

func _vertical_movement(delta):
	_gravity(delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and _jumps > 0:
		velocity.y = jump_velocity
		_jumps -= 1
		animation.play("locomotion-library/jump")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "locomotion-library/death":
		respawn()
