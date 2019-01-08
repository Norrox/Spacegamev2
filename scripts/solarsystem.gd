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
		$enemy.queue_free()
		leavecombat()

func _closelandedmenu():
	#close the landed menu and reset info boxes
	get_tree().paused = false
	$landedmenu.queue_free()
	var gui = get_node("/root/main/gui/")
	gui._systemviewmode()

func _openlandedmenu(planetchoice):
	#called when colliding with planet - should be moved out of main probably
	var p = landedmenu.instance()
	p.currentplanet = planetchoice.get_parent().get_parent()
	#set planet map view to same noise texture as system sphere
	var noisetex = NoiseTexture.new()
	noisetex.set_height(700)
	noisetex.set_width(1100)
	noisetex.set_seamless(true)
	var simplenoise = OpenSimplexNoise.new()
	simplenoise.seed = p.currentplanet.seed1
	simplenoise.period = p.currentplanet.period
	simplenoise.persistence = p.currentplanet.persistence
	simplenoise.set_lacunarity(p.currentplanet.lacunarity)
	noisetex.set_noise(simplenoise)
	var planetsprite = p.currentplanet.get_node("Sprite")
	var planet = planetchoice.get_parent().get_parent()
	var colorchoice = p.currentplanet.colorchoice
	p.get_node("Sprite").set_modulate(colorchoice)
	p.get_node("Sprite").texture = noisetex
	p.get_node("Sprite/scanline").set_modulate(Color(1, 1, 1))
	var gui = get_node("/root/main/gui/")
	gui._planetviewmode(planetchoice)
	add_child(p)
	#call landedmenu function to distribute planets assigned resources
	p._distributeminerals(planetchoice.get_parent().get_parent())
	#make the map zoom in as the menu appears
	p._zoommap()
	get_tree().paused = true

func _leavesolarsystem():
	#when solar system is exited, return to universe scene and reset info
	var gui = get_node("/root/main/gui/")
	gui._universeviewmode()
	for x in $system.minimapdotlist:
		x.queue_free()
	for x in $system.circlelist:
		x.queue_free()
	camera.zoom = Vector2(1.0, 1.0)
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
