extends Control


func _on_play_pressed():
	level_definitions.game_level = 1
	level_definitions.lives = 3
	get_tree().change_scene_to_file("res://Scenes/test_scene.tscn")


func _on_quit_pressed():
	get_tree().quit()
