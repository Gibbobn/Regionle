extends Node3D

var dragging = false
var speed = 0.1
var isIdle = false
var idle = 0

var mouseVel = Vector2.ZERO
var velocity = 0
var tempVel = 0

@onready var cam = $".".get_parent().get_parent().get_node("Camera3D")

func _input(e):
	if e is InputEventMouseButton and e.is_pressed():
		dragging = true
	if e is InputEventMouseButton and not e.is_pressed():
		dragging = false
	if e is InputEventMouseMotion and dragging:
		mouseVel = e.get_screen_relative()
		velocity+=mouseVel.x
		isIdle=false
		idle=0
	if !dragging:
		mouseVel = Vector2.ZERO
		isIdle = true

func _process(delta):
	#rotate_x(velocity.y*delta*speed)
	#rotate_y(velocity.x*delta*speed)
	if isIdle:
		idle+=1
	if idle >= 100:
		velocity+=0.2
	speed=cam.fov/750
	tempVel=velocity*delta*speed
	#print(transform.rotated_local())
	#else:
		#set_rotation()
	rotate_object_local(Vector3.UP, tempVel)
	velocity*=0.9

#youtube tutorial
#extends Node3D
#
#var rotating = false
#var prevMouse
#var nextMouse
#
#func _process(delta):
	#if Input.is_action_just_pressed("mouse_l"):
		#rotating = true
		#prevMouse = get_viewport().get_mouse_position()
	#if Input.is_action_just_released("mouse_l"):
		#rotating = false
	#
	#if rotating:
		#nextMouse = get_viewport().get_mouse_position()
		#rotate_y((nextMouse.x - prevMouse.x) * 0.1 * delta)
		#rotate_x((nextMouse.y - prevMouse.y) * 0.1 * delta)
		#prevMouse = nextMouse

#continous motion early version
#extends Node3D
#
#var mouse_start = Vector2(0,0)
#var mouse_end = Vector2(0,0)
#var dragging = false
#var speed = 0.0001
#
#@onready var cam = $".".get_parent().get_node("Camera3D")
#@onready var x_axis = cam.get_camera_transform().basis[0]
#@onready var y_axis = cam.get_camera_transform().basis[1]
#
#func _input(e):
	#if e is InputEventMouseButton and e.is_pressed():
		#mouse_start = e.position
		#dragging = true
	#if e is InputEventMouseButton and not e.is_pressed():
		#mouse_start = Vector2(0,0)
		#mouse_end = Vector2(0,0)
		#dragging = false
	#if dragging:
		#mouse_end = e.position
		#
#func _process(delta):
	#if dragging:
		#var mouse_dir = Vector2(mouse_end.x - mouse_start.x, mouse_end.y - mouse_start.y)
		##the bigger variable speed is, the faster it'll rotate.
		#rotate(y_axis, mouse_dir.x*speed)
		#rotate(x_axis, mouse_dir.y*speed)
