extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust

var thrust = Vector2()
var rotation_dir = 0
var screensize
var max_speed = 500
var exhaust_length = 0
var max_exhaust_length = 10


func _ready():
	screensize = get_viewport().get_visible_rect().size

func get_input():
	if Input.is_action_pressed("player_thrust"):
		thrust = Vector2(engine_thrust, 0)
		if exhaust_length < max_exhaust_length:
			exhaust_length += 1
	else:
		if exhaust_length > 0:
			exhaust_length -= 1
		thrust = Vector2()
	rotation_dir = 0
	if Input.is_action_pressed("player_right"):
		rotation_dir += 1
	if Input.is_action_pressed("player_left"):
		rotation_dir -= 1

func _physics_process(delta):
	get_input()
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
		var new_speed = get_linear_velocity().normalized()
		new_speed *= max_speed
		set_linear_velocity(new_speed)

func _integrate_forces(state):
	
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
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
	if "landableplanet" in area:
		if area.landableplanet == true:
			get_node("/root/main")._openlandedmenu(area)
		else:
			return
	else:
		return
	
