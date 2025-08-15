extends CharacterBody2D

@export var move_speed: float = 200
@export var max_health: int = 1

@onready var scene = $".."
@onready var rc_down = $RaycastDown
@onready var weapon = $"Weapon"
@onready var load_beam = preload("res://Scenes/invader_beam.tscn")
@onready var beam = load_beam
@onready var invader_manager = $"../../InvaderManager"

var direction: int = -1
var previous_direction: int 
var current_health: int = max_health
var moving_down: bool = false
var current_height: Vector2
var dead: bool = false

func _ready():
	await Engine.get_main_loop().process_frame
	connect_with_bounds()
	invader_manager.check_if_shooter.connect(_on_check_if_shooter)

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

func hit():
	current_health = current_health - 1
	if current_health < 0:
		current_health = 0
	if current_health == 0:
		destroy()

func destroy():
	invader_manager.shooters.erase(self)
	dead = true
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

func _on_enemy_detection_body_entered(body):
	previous_direction = direction
	moving_down = true
	current_height = position

func _on_check_if_shooter():
	if !rc_down.is_colliding() and invader_manager.shooters.find(self) == -1 and !dead:
		invader_manager.shooters.append(self)
