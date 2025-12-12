extends Camera3D

func _input(event):
	if event.is_action_pressed("scroll_up"):
		fov-=5
	if event.is_action_pressed("scroll_down"):
		fov+=5
