extends RigidBody3D

@export var rotation_speed = 1
@export var rotation_vector: Vector3 = Vector3(0, 1, 0)

func _ready():
	rotation_vector = rotation_vector.normalized()

func _physics_process(delta):
	rotate(rotation_vector, rotation_speed*delta)
