extends RigidBody3D

@export var move_speed = 10
@export var max_move_distance = 50
@export var move_direction: Vector3 = Vector3(0, 1, 0)

var _distance_moved = 0

func _ready():
	move_direction = move_direction.normalized()

func _physics_process(delta):
	var distance_to_move = move_direction * move_speed * delta
	_distance_moved += abs(global_position.distance_to(global_position + distance_to_move))
	
	print(_distance_moved)
	
	if _distance_moved > max_move_distance:
		move_direction *= -1
		_distance_moved = 0
	else:
		global_position += distance_to_move
