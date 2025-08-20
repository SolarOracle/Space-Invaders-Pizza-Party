extends Node

@onready var player = get_node("/root/TestScene/PlayerTest")
@onready var invader_manager = $"../InvaderManager"
@onready var points_label = %PointsLabel

var total_score: int

func _ready():
	player.death.connect(_on_player_death)

func lose_game():
	pass

func win_game():
	pass

func update_score(score):
	total_score += score
	if total_score < 100:
		points_label.text = ("00" + "%s" % total_score)
	elif total_score > 99:
		points_label.text = ("0" + "%s" % total_score)
	elif total_score > 999:
		points_label.text = ("%s" % total_score)

func _on_player_death():
	invader_manager.shot_timer.paused = true
	lose_game()
