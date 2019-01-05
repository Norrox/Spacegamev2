extends RigidBody2D

export (int) var enginethrust
export (int) var spinthrust

var rotation_dir = 0
var screensize
var max_speed = 500
var exhaust_length = 0
var max_exhaust_length = 10


func _ready():
	screensize = get_viewport().get_visible_rect().size #get size of screen to use in edge wrapping


func _integrate_forces(state):
	#get current velocity
	var currentvel = sqrt(pow(abs(get_linear_velocity().x), 2) + pow(abs(get_linear_velocity().y), 2))
	#if acceleration is pressed
	if Input.is_action_pressed("player_thrust"):
		#increase exhaust trail
		if exhaust_length < max_exhaust_length:
			exhaust_length += 1
		#apply engine force in direction pointing
		set_applied_force(Vector2(enginethrust,0).rotated(rotation))
		#apply opposite directional force that scales as approaching max speed
		var oppositetravel = Vector2(get_linear_velocity().x * -1, get_linear_velocity().y * -1)
		oppositetravel = oppositetravel * (currentvel / max_speed)
		add_force(Vector2(0,0), oppositetravel)
	else:
		#set force applied to zero
		set_applied_force(Vector2())
		if exhaust_length > 0:
			exhaust_length -= 1
	rotation_dir = 0
	#rotate direction
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	#apply rotational force
	set_applied_torque(rotation_dir * spinthrust)
	#edge wrapping, teleport to other side of map
	var xform = state.transform
	if xform.origin.x > 10000:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = 10000
	if xform.origin.y > 6250:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = 6250
	state.transform = xform


func _on_Area2D_area_entered(area):
	#detect collision with landable planet
	if "landableplanet" in area:
		if area.landableplanet == true:
			get_node("/root/main")._openlandedmenu(area)
		else:
			return
	else:
		return
	
