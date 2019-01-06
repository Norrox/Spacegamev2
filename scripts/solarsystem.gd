extends Node

var systemdict
var combatstatus = false
signal combat_signal
signal leave_combat
onready var enemyship = preload("res://scenes/enemy.tscn")

func _ready():
	pass

func _input(event):
	if event.is_action("ui_focus_next") and event.is_pressed() and not event.is_echo():
		var p = enemyship.instance()
		add_child(p)
		declarecombat()
	if event.is_action("ui_cancel") and event.is_pressed() and not event.is_echo():
		$enemy.queue_free()
		leavecombat()

func declarecombat():
	emit_signal("combat_signal")

func leavecombat():
	emit_signal("leave_combat")
	
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


func _on_solarsystem_combat_signal():
	get_node("/root/main/gui/frame").color = Color(255, 0, 0, 255)


func _on_solarsystem_leave_combat():
	get_node("/root/main/gui/frame").color = Color(255, 255, 255, 255)
