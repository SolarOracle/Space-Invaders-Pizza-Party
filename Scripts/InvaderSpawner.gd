extends Node

class_name InvaderSpawner

const columns = 12
const rows = 5

@export var invader: PackedScene
@export var margin: Vector2 = Vector2(1,1)
@export var spawn_start: Marker2D

@onready var bounds_left = get_node("/root/TestScene/Bounds/BoundsLeft")
@onready var bounds_right = get_node("/root/TestScene/Bounds/BoundsRight")

var invader_count: int = 0

func _ready():
	spawn()
	await Engine.get_main_loop().process_frame
	bounds_left.process_mode = Node.PROCESS_MODE_ALWAYS
	bounds_right.process_mode = Node.PROCESS_MODE_ALWAYS
	
func spawn():
	var test_invader = invader.instantiate()
	add_child(test_invader)
	var invader_size = test_invader.get_size()
	test_invader.queue_free()
	
	var row_width = invader_size.x * columns + margin.x * (columns - 1)
	var spawn_position_x = spawn_start.position.x
	var spawn_position_y = spawn_start.position.y
	
	for i in rows:
		for j in columns:
			var new_invader = invader.instantiate()
			add_child(new_invader)
			var x = spawn_position_x + j * (margin.x + new_invader.get_size().x) * 0.45
			var y = spawn_position_y + i * (margin.y + new_invader.get_size().y) * 0.4
			new_invader.set_position(Vector2(x, y))
