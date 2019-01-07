extends RigidBody2D

var enginethrust = 500
var spinthrust = 2000

var rotation_dir = 0
var screensize
var max_speed = 300
var exhaust_length = 0
var max_exhaust_length = 10
var target
var engineon = 0

func _ready():
	screensize = get_viewport().get_visible_rect().size #get size of screen to use in edge wrapping
	target = get_parent().get_node("player")
	
func _process(delta):
	var targetposition = target.global_position
	var targetvec = targetposition - self.global_position
	targetvec = targetvec.normalized()
	var pointingvec = Vector2(1, 0).rotated(self.global_rotation)
	pointingvec = pointingvec.normalized()
	var doterror = targetvec.dot(pointingvec)
	var anglebetween = pointingvec.angle_to(targetvec)
	anglebetween = rad2deg(anglebetween)
	var distancetoplayer = self.global_position.distance_to(targetposition)
	aidecision(anglebetween, distancetoplayer)
	
func aidecision(anglebetween, distancetoplayer):
	randomize()
	if distancetoplayer < 200:
		engineon = 0
	elif anglebetween < 10 and anglebetween > -10:
		engineon = 1
	if anglebetween < 180 and anglebetween > 9:
		rotation_dir += 1
		engineon = 0
	if anglebetween > -180 and anglebetween < -9:
		rotation_dir -= 1
		engineon = 0

func _integrate_forces(state):
	#get current velocity
	var currentvel = sqrt(pow(abs(get_linear_velocity().x), 2) + pow(abs(get_linear_velocity().y), 2))
	#if acceleration is pressed
	if engineon == 1:
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
	#rotate direction
	#apply rotational force
	if spinthrust != 0 and rotation_dir != 0:
		set_applied_torque(rotation_dir * spinthrust)
	rotation_dir = 0
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