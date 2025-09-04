extends Node

@export var ufo: PackedScene

@onready var scene = $".."

var shots_fired: int = 0
var shots_until_ufo: int = randi_range(15, 25)

func shot_fired():
	shots_fired += 1
	if shots_fired >= shots_until_ufo:
		spawn_ufo()
		shots_fired = 0
		shots_until_ufo = randi_range(15, 25)

func spawn_ufo():
	var new_ufo = ufo.instantiate()
	scene.add_child(new_ufo)
