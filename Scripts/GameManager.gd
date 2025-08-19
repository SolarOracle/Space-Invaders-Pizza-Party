extends Node

@onready var player = get_node("/root/TestScene/PlayerTest")
@onready var invader_manager = $"../InvaderManager"

var total_score: int

func _ready():
	player.death.connect(_on_player_death)

func lose_game():
	pass

func update_score(score):
	total_score += score

func _on_player_death():
	invader_manager.shot_timer.paused = true
	lose_game()
