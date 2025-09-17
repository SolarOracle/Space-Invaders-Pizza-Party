extends Node

@onready var player = get_node("/root/TestScene/PlayerTest")
@onready var load_player = preload("res://Scenes/player_test.tscn")
@onready var invader_manager = %InvaderManager
@onready var ufo_spawner = get_node("/root/TestScene/UFOSpawner")
@onready var points_label = %PointsLabel
@onready var lives_label = %LivesNumberLabel
@onready var ready_label = %ReadyLabel
@onready var win_label = %WinLabel
@onready var lose_label = %LoseLabel
@onready var level_label = %LevelLabel
@onready var pause_menu = %PauseMenu
@onready var scene = $".."
@onready var bounds_left = get_node("/root/TestScene/Bounds/BoundsLeft")
@onready var bounds_right = get_node("/root/TestScene/Bounds/BoundsRight")

var starting_position: Vector2
signal reset_position
signal activate
signal position_invader_marker

func _ready():
	update_score(0)
	lives_label.text = ("%s" % level_definitions.lives)
	starting_position = player.position
	player.death.connect(_on_player_death)
	position_invader_marker.emit(level_definitions.game_level)
	start_delay()

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		if player != null and player.active and invader_manager.invader_count > 0:
			pause()
		elif (pause_menu.visible == false and win_label.visible) or (pause_menu.visible == false and lose_label.visible):
			get_tree().quit()
	
	if Input.is_action_just_pressed("shoot"):
		if pause_menu.visible == false and level_label.visible:
			level_definitions.game_level += 1
			get_tree().reload_current_scene()

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
	if player != null:
		player.queue_free()
	lives_label.text = ("%s" % level_definitions.lives)
	lose_label.text = ("""GAME LOST!
	FINAL SCORE - %s

	PRESS ESC TO QUIT""" % level_definitions.total_score)
	lose_label.show()

func win_level():
	await get_tree().create_timer(0.5).timeout
	player.active = false
	ufo_spawner.shots_fired = 0
	ufo_spawner.shots_until_ufo = randi_range(15, 25)
	level_label.text = ("""LEVEL WON!
	CURRENT SCORE - %s
	
	PRESS SPACE TO PROCEED""" % level_definitions.total_score)
	level_label.show()

func win_game():
	await get_tree().create_timer(0.5).timeout
	player.active = false
	win_label.text = ("""YOU WIN!
	TOTAL SCORE - %s
	
	NICE JOB!
	PRESS ESC TO QUIT""" % level_definitions.total_score)
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
	ufo_spawner.shots_fired = 0
	ufo_spawner.shots_until_ufo = randi_range(15, 25)
	lives_label.text = ("%s" % level_definitions.lives)
	start_delay()

func update_score(score):
	level_definitions.total_score += score
	if level_definitions.total_score < 10:
		points_label.text = ("000" + "%s" % level_definitions.total_score)
	elif level_definitions.total_score < 100:
		points_label.text = ("00" + "%s" % level_definitions.total_score)
	elif level_definitions.total_score < 1000:
		points_label.text = ("0" + "%s" % level_definitions.total_score)
	else:
		points_label.text = ("%s" % level_definitions.total_score)

func _on_player_death():
	invader_manager.shot_timer.paused = true
	level_definitions.lives -= 1
	if level_definitions.lives > 0:
		lose_life()
	else:
		lose_game()
