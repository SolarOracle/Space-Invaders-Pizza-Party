extends CharacterBody2D

@export var move_speed: float = 150
@export var max_health: int = 1

@onready var scene = $".."
@onready var rc_down = $RaycastDown
@onready var weapon = $"Weapon"
@onready var load_beam = preload("res://Scenes/invader_beam.tscn")
@onready var beam = load_beam
@onready var invader_manager = $"../../InvaderManager"
@onready var game_manager = $"../../GameManager"

var direction: int = -1
var level: int
var previous_direction: int 
var score: int
var current_health: int = max_health
var moving_down: bool = false
var current_height: Vector2
var dead: bool = false

func _ready():
	await Engine.get_main_loop().process_frame
	connect_with_bounds()
	invader_manager.check_if_shooter.connect(_on_check_if_shooter)
	invader_manager.update_speed.connect(_on_update_speed)

func _physics_process(delta):
	move_and_slide()
	if moving_down == false:
		position += transform.x * direction * delta * move_speed
	else:
		position += transform.y * delta * move_speed
		if position.distance_to(current_height) >= 30:
			position.y -= position.distance_to(current_height) - 30
			direction = previous_direction * -1
			moving_down = false
			check_position()

func hit():
	current_health = current_health - 1
	if current_health < 0:
		current_health = 0
	if current_health == 0:
		destroy()

func destroy():
	get_score()
	invader_manager.shooters.erase(self)
	dead = true
	game_manager.update_score(score)
	invader_manager.invader_death()
	queue_free()

func shoot():
	beam = load_beam.instantiate()
	scene.add_child(beam)
	beam.global_position = weapon.global_position

func get_size():
	return $CollisionShape2D.shape.get_rect().size

func connect_with_bounds():
	await Engine.get_main_loop().process_frame
	$"../../Bounds/BoundsLeft/EnemyDetection".body_entered.connect(_on_enemy_detection_body_entered)
	$"../../Bounds/BoundsRight/EnemyDetection".body_entered.connect(_on_enemy_detection_body_entered)

func check_position():
	if position.y >= 475:
		game_manager.lose_game()

func get_score():
	score = level * 10

func _on_enemy_detection_body_entered(body):
	previous_direction = direction
	moving_down = true
	current_height = position

func _on_check_if_shooter():
	if !rc_down.is_colliding() and invader_manager.shooters.find(self) == -1 and !dead:
		invader_manager.shooters.append(self)

func _on_update_speed(speed):
	move_speed = speed
