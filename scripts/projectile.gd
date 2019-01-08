extends RigidBody2D

var projectileforce

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	var xform = state.transform
	if xform.origin.x > 10000:
		queue_free()
	if xform.origin.x < 0:
		queue_free()
	if xform.origin.y > 6250:
		queue_free()
	if xform.origin.y < 0:
		queue_free()
	state.transform = xform



func _on_Timer_timeout():
	queue_free()
