extends CharacterBody3D

@export var speed = 10

var direction = Vector3.ZERO

func setup(dir: Vector3):
	direction = dir.normalized()

func _physics_process(delta):
	global_position += direction * speed * delta
	
func _on_timer_timeout():
	queue_free()
