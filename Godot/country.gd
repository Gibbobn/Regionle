extends Area2D

func _ready() -> void:
	get_parent().colour_change.connect(_on_colour_change)
	
func _on_colour_change(num, rgb):
	if self.name == str(num):
		self.modulate = rgb
