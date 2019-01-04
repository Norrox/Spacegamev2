extends Node2D

var scantime = 2.0
onready var tween = $Tween
var time = 2.0
var selection = 1
var currentplanet
var commonamount = 0
var metalamount = 0
var uncommonamount = 0
var preciousamount = 0
var radioactiveamount = 0
var exoticamount = 0

onready var resourcedot = preload("res://scenes/mineralresource.tscn")
var commonicon = preload("res://art/sprites/commonicon.png")
var metallicicon = preload("res://art/sprites/metalicon.png")
var uncommonicon = preload("res://art/sprites/uncommonicon.png")
var radioactiveicon = preload("res://art/sprites/radioactiveicon.png")
var preciousicon = preload("res://art/sprites/preciousicon.png")
var exoticicon = preload("res://art/sprites/exoticicon.png")
onready var scanline = $Sprite/scanline
var scanlinegroup = []
var freezecontrols = false
var scanbool = false
# Called when the node enters the scene tree for the first time.
var resourcelist = []
func _ready():
	selection = 1
	get_parent().get_node("gui/scan").color = Color(0.2, 0.3, 0.37)
	get_parent().get_node("gui/land").color = Color(0.03, 0.03, 0.03)
	get_parent().get_node("gui/leave").color = Color(0.03, 0.03, 0.03)
	var planetguiboxes = get_tree().get_nodes_in_group("planettext")
	for x in planetguiboxes:
		x.show()
	get_parent().get_node("gui/common").text = "Common : "
	get_parent().get_node("gui/metals").text = "Metal : "
	get_parent().get_node("gui/uncommon").text = "Uncommon : "
	get_parent().get_node("gui/precious").text = "Precious : "
	get_parent().get_node("gui/radioactive").text = "Radioactive : "
	get_parent().get_node("gui/exotic").text = "Exotic : "

func _zoommap():
	$Tween.interpolate_property($Sprite, "scale", Vector2(0,0), Vector2(1.0,1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _input(event):
	if freezecontrols == false:
		if event.is_action("ui_down") and event.is_pressed() and not event.is_echo():
			if selection == 3:
				selection = 1
				_changerectcolor()
				return
			else:
				selection += 1
				_changerectcolor()
				return
		if event.is_action("ui_up") and event.is_pressed() and not event.is_echo():
			if selection == 1:
				selection = 3
				_changerectcolor()
				return
			else:
				selection -= 1
				_changerectcolor()
				return
		if event.is_action("ui_accept") and event.is_pressed() and not event.is_echo():
			if selection == 1:
				if scanline.position.y == -50:
					_scan()
				else:
					return
			elif selection == 2:
				_land()
			elif selection == 3:
				_leave()
	else:
		return

func _changerectcolor():
	if selection == 1:
		get_parent().get_node("gui/scan").color = Color(0.2, 0.3, 0.37)
		get_parent().get_node("gui/land").color = Color(0.03, 0.03, 0.03)
		get_parent().get_node("gui/leave").color = Color(0.03, 0.03, 0.03)
	elif selection == 2:
		get_parent().get_node("gui/scan").color = Color(0.03, 0.03, 0.03)
		get_parent().get_node("gui/land").color = Color(0.2, 0.3, 0.37)
		get_parent().get_node("gui/leave").color = Color(0.03, 0.03, 0.03)
	elif selection == 3:
		get_parent().get_node("gui/scan").color = Color(0.03, 0.03, 0.03)
		get_parent().get_node("gui/land").color = Color(0.03, 0.03, 0.03)
		get_parent().get_node("gui/leave").color = Color(0.2, 0.3, 0.37)


func _scan():
	scanbool = true
	scanline.show()

func _process(delta):
	if scanbool == true:
		scanline.position.y += 200 * delta
		if scanline.position.y > 700:
			scanbool = false
			scanline.hide()
			scanline.position.y = -50
			currentplanet.resourcesscanned = true
			for x in resourcelist:
				x.show()
				if x.resourcegroup == 1:
					commonamount += x.resourcesize
				elif x.resourcegroup == 2:
					metalamount += x.resourcesize
				elif x.resourcegroup == 3:
					uncommonamount += x.resourcesize
				elif x.resourcegroup == 4:
					preciousamount += x.resourcesize
				elif x.resourcegroup == 5:
					radioactiveamount += x.resourcesize
				elif x.resourcegroup == 6:
					exoticamount += x.resourcesize
				currentplanet.common = commonamount
				currentplanet.metal = metalamount
				currentplanet.uncommon = uncommonamount
				currentplanet.precious = preciousamount
				currentplanet.radioactive = radioactiveamount
				currentplanet.exotic = exoticamount
				var commonstring = str("common: " + str(commonamount))
				get_parent().get_node("gui/common").set_text(commonstring)
				var exoticstring = str("exotics: " + str(exoticamount))
				get_parent().get_node("gui/exotic").set_text(exoticstring)
				var metalstring = str("metals: " + str(metalamount))
				get_parent().get_node("gui/metals").set_text(metalstring)
				var uncommonstring = str("uncommon: " + str(uncommonamount))
				get_parent().get_node("gui/uncommon").set_text(uncommonstring)
				var preciousstring = str("precious: " + str(preciousamount))
				get_parent().get_node("gui/precious").set_text(preciousstring)
				var radioactivestring = str("radioactives: " + str(radioactiveamount))
				get_parent().get_node("gui/radioactive").set_text(radioactivestring)
	else:
		return

func _land():
	pass
	
func _leave():
	currentplanet.get_node("Sprite/landing").landableplanet = false
	currentplanet.get_node("collisiontimer").start()
	get_parent()._closelandedmenu()
	
func _distributeminerals(planet):
	currentplanet = planet
	var p
	for x in range(0, planet.resourcelocationlist.size(), 1):
		p = resourcedot.instance()
		p.resourcegroup = planet.resourcetypelist[x]
		p.resourcesize = planet.resourcesizelist[x]
		var scalefactor = planet.resourcesizelist[x] / 30
		if scalefactor < 1:
			scalefactor = 1
		p.scale = Vector2(0.04 * scalefactor, 0.04 * scalefactor)
		add_child(p)
		if p.resourcegroup == 1:
			p.get_node("Sprite").set_texture(commonicon)
		elif p.resourcegroup == 2:
			p.get_node("Sprite").set_texture(metallicicon)
		elif p.resourcegroup == 3:
			p.get_node("Sprite").set_texture(uncommonicon)
		elif p.resourcegroup == 4:
			p.get_node("Sprite").set_texture(preciousicon)
		elif p.resourcegroup == 5:
			p.get_node("Sprite").set_texture(radioactiveicon)
		elif p.resourcegroup == 6:
			p.get_node("Sprite").set_texture(exoticicon)
		resourcelist.append(p)
		p.hide()
		p.position.x = planet.resourcelocationlist[x].x
		p.position.y = planet.resourcelocationlist[x].y



func _on_Tween_tween_completed(object, key):
	if currentplanet.resourcesscanned == true:
		for p in resourcelist:
			p.show()
		var commonstring = str("common: " + str(currentplanet.common))
		get_parent().get_node("gui/common").set_text(commonstring)
		var exoticstring = str("exotics: " + str(currentplanet.exotic))
		get_parent().get_node("gui/exotic").set_text(exoticstring)
		var metalstring = str("metals: " + str(currentplanet.metal))
		get_parent().get_node("gui/metals").set_text(metalstring)
		var uncommonstring = str("uncommon: " + str(currentplanet.uncommon))
		get_parent().get_node("gui/uncommon").set_text(uncommonstring)
		var preciousstring = str("precious: " + str(currentplanet.precious))
		get_parent().get_node("gui/precious").set_text(preciousstring)
		var radioactivestring = str("radioactives: " + str(currentplanet.radioactive))
		get_parent().get_node("gui/radioactive").set_text(radioactivestring)
		
	