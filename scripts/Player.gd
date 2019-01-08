extends RigidBody2D



var enginethrust = 500
var spinthrust = 2000
var rotation_dir = 0
var screensize
var max_speed = 500
var exhaust_length = 0
var max_exhaust_length = 10
var combatstatus = false
var playership = true
var projectilecooldown = 100
var projectileforce = 100
onready var projectile = preload("res://scenes/projectile.tscn")

func _ready():
	screensize = get_viewport().get_visible_rect().size #get size of screen to use in edge wrapping
	

func _integrate_forces(state):
	var oppositetravel = Vector2(get_linear_velocity().x * -1, get_linear_velocity().y * -1)
	var pointingvec = Vector2(1, 0).rotated(self.global_rotation)
	if projectilecooldown > 0:
		projectilecooldown -= 1
	if Input.is_action_pressed("ui_select"):
		if projectilecooldown == 0:
			projectilecooldown = 50
			_createprojectile($firingposition.position, pointingvec)
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
		var oppositeforce = oppositetravel * (currentvel / max_speed)
		add_force(Vector2(0,0), oppositeforce)
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
	if combatstatus == true:
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
	if combatstatus == false:
		if "landableplanet" in area:
			if area.landableplanet == true:
				get_parent()._openlandedmenu(area)
			else:
				return
		else:
			return
	

func _createprojectile(position, direction):
	var p = projectile.instance()
	p.position = position
	add_child(p)
	var oppositetravel = Vector2(direction.x * -1, direction.y * -1)
	apply_impulse(Vector2(0, 0), oppositetravel * (projectileforce / 2))
	p.apply_impulse(Vector2(0,0), direction * (projectileforce * 10))


func _on_solarsystem_combat_signal():
	combatstatus = true


func _on_solarsystem_leave_combat():
	combatstatus = false
