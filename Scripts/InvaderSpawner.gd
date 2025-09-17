extends Node

class_name InvaderSpawner

const columns = 12
const rows = 5

@export var invader: PackedScene
@export var margin: Vector2 = Vector2(1,1)
@export var spawn_start: Marker2D

@onready var invader_manager = %InvaderManager

var invader_count: int = 0

func _ready():
	await Engine.get_main_loop().process_frame
	spawn()

func spawn():
	var spawn_position_x = spawn_start.position.x
	var spawn_position_y = spawn_start.position.y
	
	for i in rows:
		for j in columns:
			var new_invader = invader.instantiate()
			add_child(new_invader)
			var x = spawn_position_x + j * (margin.x + new_invader.get_size().x) * 0.45
			var y = spawn_position_y + i * (margin.y + new_invader.get_size().y) * 0.4
			
			var float_i = float(i)
			new_invader.set_position(Vector2(x, y))
			invader_manager.invader_count += 1
			new_invader.level = 3.0 - (ceil(float_i / 2.0))


func _on_game_manager_position_invader_marker(level):
	spawn_start.position.y = 50 + ((level - 1) * 60)
