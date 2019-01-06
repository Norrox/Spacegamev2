extends Node

var systemdict

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func generatesystem(systemdict):
	$system._generatesystem(systemdict)
	


func _on_topbar_body_entered(body):
	if "playership" in body:
		get_node("/root/main")._leavesolarsystem()


func _on_leftbar_body_entered(body):
	if "playership" in body:
		get_node("/root/main")._leavesolarsystem()


func _on_bottombar_body_entered(body):
	if "playership" in body:
		get_node("/root/main")._leavesolarsystem()


func _on_rightbar_body_entered(body):
	if "playership" in body:
		get_node("/root/main")._leavesolarsystem()
