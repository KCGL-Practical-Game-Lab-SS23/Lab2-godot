extends Node3D

@export var shoot_interval = 2

const ROCK = preload("res://objects/obstacles/rock.tscn")
const ROCK_TYPE = preload("res://objects/obstacles/rock.gd")

@onready var shoot_direction: Vector3 = ($Aim.global_position - global_position).normalized()

func _ready():
	$ShootInterval.start(shoot_interval)

func _on_shoot_interval_timeout():
	var new_rock: ROCK_TYPE = ROCK.instantiate()
	new_rock.setup(shoot_direction)
	owner.add_child(new_rock)
	new_rock.global_position = global_position
	
