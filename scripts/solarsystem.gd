extends Node

var systemdict
var combatstatus = false
signal combat_signal
signal leave_combat
onready var enemyship = preload("res://scenes/enemy.tscn")
onready var landedmenu = preload("res://scenes/landedmenu.tscn")
onready var camera = get_node("/root/main/viewportcontainer/viewport/camera2d")

func _ready():
	pass

func _input(event):
	if event.is_action("ui_focus_next") and event.is_pressed() and not event.is_echo():
		var p = enemyship.instance()
		add_child(p)
		declarecombat()
	if event.is_action("ui_cancel") and event.is_pressed() and not event.is_echo():
		if $player.combatstatus == true:
			$enemy.queue_free()
			leavecombat()

func _closelandedmenu(planet):
	#close the landed menu and reset info boxes
	get_node("/root/main/globeview/").queue_free()
	get_node("/root/main/").remove_child(planet.storedlandedscene)
	get_tree().paused = false
	var gui = get_node("/root/main/gui/")
	gui._systemviewmode()

func _openlandedmenu(planetchoice):
	var gui = get_node("/root/main/gui/")
	gui._planetviewmode(planetchoice)
	var p = planetchoice.get_parent().get_parent().storedlandedscene
	for x in p.resourcelist:
		x.hide()
	get_node("/root/main/").add_child(p)
	#call landedmenu function to distribute planets assigned resources
	p._distributeminerals(planetchoice.get_parent().get_parent())
	#make the map zoom in as the menu appears
	p._zoommap()
	get_tree().paused = true

func _leavesolarsystem():
	for x in $system.baseplanetlist:
		if "storedlandedscene" in x:
			x.storedlandedscene.queue_free()
			x.storedlandedscene = null
	#when solar system is exited, return to universe scene and reset info
	camera.target = null
	var gui = get_node("/root/main/gui/")
	gui._universeviewmode()
	for x in $system.minimapdotlist:
		x.queue_free()
	for x in $system.circlelist:
		x.queue_free()
	camera.zoom = Vector2(1.0, 1.0)
	camera.position = Vector2(0, 0)
	get_node("/root/main/viewportcontainer/viewport").add_child(get_node("/root/main/").currentuniverse)
	queue_free()

func declarecombat():
	emit_signal("combat_signal")

func leavecombat():
	emit_signal("leave_combat")
	
func generatesystem(systemdict):
	$system._generatesystem(systemdict)
	
func _on_topbar_body_entered(body):
	if "playership" in body:
		_leavesolarsystem()

func _on_leftbar_body_entered(body):
	if "playership" in body:
		_leavesolarsystem()

func _on_bottombar_body_entered(body):
	if "playership" in body:
		_leavesolarsystem()

func _on_rightbar_body_entered(body):
	if "playership" in body:
		_leavesolarsystem()


func _on_solarsystem_combat_signal():
	get_node("/root/main/gui/frame").color = Color(255, 0, 0, 255)


func _on_solarsystem_leave_combat():
	get_node("/root/main/gui/frame").color = Color(255, 255, 255, 255)
