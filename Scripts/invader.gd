extends CharacterBody2D

@export var move_speed : float = 300
@export var max_health : int = 1

@onready var scene = $".."
@onready var rc_down = $RaycastDown
@onready var weapon = $"Weapon"
@onready var load_beam = preload("res://Scenes/invader_beam.tscn")
@onready var beam = load_beam

var direction : int = -1
var previous_direction : int 
var current_health : int = max_health
var moving_down : bool = false
var current_height : Vector2

func _ready():
	await get_tree().process_frame
	$"../Bounds/BoundsLeft/EnemyDetection".body_entered.connect(_on_enemy_detection_body_entered)
	$"../Bounds/BoundsRight/EnemyDetection".body_entered.connect(_on_enemy_detection_body_entered)

func _physics_process(delta):
	move_and_slide()
	if moving_down == false:
		position += transform.x * direction * delta * move_speed
	else:
		position += transform.y * delta * move_speed
		if position.distance_to(current_height) >= 40:
			position.y -= position.distance_to(current_height) - 40
			direction = previous_direction * -1
			moving_down = false

func hit():
	current_health = current_health - 1
	if current_health < 0:
		current_health = 0
	if current_health == 0:
		destroy()

func destroy():
	queue_free()

func _on_enemy_detection_body_entered(body):
	previous_direction = direction
	moving_down = true
	current_height = position

func shoot():
	beam = load_beam.instantiate()
	scene.add_child(beam)
	beam.global_position = weapon.global_position
