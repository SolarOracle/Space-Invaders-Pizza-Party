extends CharacterBody2D

@export var move_speed: float = 600
@export var max_health: int = 1

@onready var spawn_left = get_node("/root/TestScene/UFOSpawner/SpawnLeft")
@onready var spawn_right = get_node("/root/TestScene/UFOSpawner/SpawnRight")
@onready var game_manager = get_node("/root/TestScene/GameManager")
@onready var invader_manager = get_node("/root/TestScene/InvaderManager")

var direction: int
var current_health: int = max_health
var score: int

func _ready():
	direction = [1, -1].pick_random()
	invader_manager.clear_shots.connect(_on_clear)
	if direction == 1:
		position = spawn_left.position
		spawn_right.body_entered.connect(_on_spawn_body_entered)
	elif direction == -1:
		position = spawn_right.position
		spawn_left.body_entered.connect(_on_spawn_body_entered)
	await Engine.get_main_loop().process_frame
	game_manager.activate.connect(_on_clear)

func _process(delta):
	move_and_slide()
	position += transform.x * direction * delta * move_speed

func hit():
	current_health = current_health - 1
	if current_health < 0:
		current_health = 0
	if current_health == 0:
		destroy()

func destroy():
	get_score()
	game_manager.update_score(score)
	queue_free()

func get_score():
	score = [50, 100, 150, 200, 300].pick_random()

func _on_spawn_body_entered(_body):
	queue_free()

func _on_clear():
	queue_free()
