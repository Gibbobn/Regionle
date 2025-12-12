extends Node3D

var dragging = false
var speed = 0.1
var isIdle = false
var idle = 0

var mouseVel = Vector2.ZERO
var velocity = 0
var tempVel = 0

@onready var cam = $".".get_parent().get_node("Camera3D")

func _input(e):
	if e is InputEventMouseButton and e.is_pressed():
		dragging = true
	if e is InputEventMouseButton and not e.is_pressed():
		dragging = false
	if e is InputEventMouseMotion and dragging:
		mouseVel = e.get_screen_relative()
		velocity+=mouseVel.y
	if !dragging:
		mouseVel = Vector2.ZERO


func _process(delta):
	#rotate_x(velocity.y*delta*speed)
	#rotate_y(velocity.x*delta*speed)
	speed=cam.fov/750
	tempVel=velocity*delta*speed
	if get_rotation().x+tempVel > (-PI/2) and get_rotation().x+tempVel < (PI/2):
		rotate(Vector3.RIGHT, tempVel)
	velocity*=0.9
