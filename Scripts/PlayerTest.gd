extends CharacterBody2D

@export var move_spd : float = 250

@onready var scene = $".."
@onready var weapon = $"Weapon"
@onready var load_beam = preload("res://Scenes/beam.tscn")
@onready var beam = load_beam
@onready var ufo_spawner = $"../UFOSpawner"

var active: bool = false
var can_shoot: bool = true
var x_input : int = 0
signal death

func _process(delta):
	x_input = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("shoot"):
		if can_shoot and active:
			shoot()

func _physics_process(delta):
	if active:
		movement(x_input, delta)

func movement(_x_input : int, delta):
	var _velocity : Vector2 = Vector2(_x_input * move_spd * delta, 0)
	
	var collision = move_and_collide(_velocity)

func shoot():
	beam = load_beam.instantiate()
	scene.add_child(beam)
	beam.global_position = weapon.global_position
	can_shoot = false
	ufo_spawner.shot_fired()

func hit():
	death.emit()
	ufo_spawner.shots_fired = 0
	ufo_spawner.shots_until_ufo = randi_range(15, 25)
	queue_free()
