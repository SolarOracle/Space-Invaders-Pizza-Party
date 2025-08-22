extends Node

@export var lives: int

@onready var player = get_node("/root/TestScene/PlayerTest")
@onready var load_player = preload("res://Scenes/player_test.tscn")
@onready var invader_manager = %InvaderManager
@onready var points_label = %PointsLabel
@onready var lives_label = %LivesNumberLabel
@onready var ready_label = %ReadyLabel
@onready var win_label = %WinLabel
@onready var pause_menu = %PauseMenu
@onready var scene = $".."
@onready var bounds_left = get_node("/root/TestScene/Bounds/BoundsLeft")
@onready var bounds_right = get_node("/root/TestScene/Bounds/BoundsRight")

var starting_position: Vector2
var total_score: int
signal reset_position
signal activate

func _ready():
	lives_label.text = ("%s" % lives)
	starting_position = player.position
	player.death.connect(_on_player_death)
	start_delay()

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if player != null and player.active and invader_manager.invader_count > 0:
			pause()
		elif pause_menu.visible == false and win_label.visible:
			get_tree().quit()

func start_delay():
	ready_label.show()
	invader_manager.clear_shots.emit()
	await get_tree().create_timer(1.5).timeout
	player.active = true
	activate.emit()
	ready_label.hide()
	invader_manager.shot_timer.start()
	invader_manager.shot_timer.paused = false
	bounds_left.process_mode = Node.PROCESS_MODE_ALWAYS
	bounds_right.process_mode = Node.PROCESS_MODE_ALWAYS

func pause():
	pause_menu.visible = !pause_menu.visible
	get_tree().paused = !get_tree().paused

func lose_game():
	await get_tree().create_timer(0.5).timeout
	activate.emit()
	lives_label.text = ("%s" % lives)

func win_game():
	await get_tree().create_timer(0.5).timeout
	player.active = false
	win_label.text = ("""YOU WIN!
	TOTAL SCORE - %s
	
	NICE JOB!
	PRESS ESC TO QUIT""" % total_score) 
	win_label.show()

func lose_life():
	await get_tree().create_timer(1.0).timeout
	player = load_player.instantiate()
	scene.add_child(player)
	player.position = starting_position
	player.death.connect(_on_player_death)
	reset_position.emit()
	activate.emit()
	player.active = false
	lives_label.text = ("%s" % lives)
	start_delay()

func update_score(score):
	total_score += score
	if total_score < 100:
		points_label.text = ("00" + "%s" % total_score)
	elif total_score < 1000:
		points_label.text = ("0" + "%s" % total_score)
	else:
		points_label.text = ("%s" % total_score)

func _on_player_death():
	invader_manager.shot_timer.paused = true
	lives -= 1
	if lives == 0:
		lose_game()
	else:
		lose_life()
