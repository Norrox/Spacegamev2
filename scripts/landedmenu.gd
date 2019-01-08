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
var resourcelist = []

func _ready():
	pass

func _zoommap():
	#zooms in the map when it opens as a slightly swish entrance
	$Tween.interpolate_property($Sprite, "scale", Vector2(0,0), Vector2(1.0,1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _input(event):
	#controls are frozen whilst scanning, otherise move menu selection
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
	#change menu selection colour based on which is currently chosen
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
	#if scan has been chosen
	if scanbool == true:
		#move scanline down
		scanline.position.y += 200 * delta
		#until reaching bottom of map, then hide it and reveal resources
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
				#add resource totals to info panel
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
	#todo
	pass
	
func _leave():
	currentplanet.get_node("Sprite/landing").landableplanet = false
	#add a collisiontimer so that you cant immediately re-collide with planet after leaving
	currentplanet.get_node("collisiontimer").start()
	get_node("/root/main/viewportcontainer/viewport/solarsystem/")._closelandedmenu(currentplanet)
	
func _distributeminerals(planet):
	#called before menu visible, resources are added, but invisible until scanned
	currentplanet = planet
	var p
	for x in range(0, planet.resourcelocationlist.size(), 1):
		p = resourcedot.instance()
		p.resourcegroup = planet.resourcetypelist[x]
		p.resourcesize = planet.resourcesizelist[x]
		var scalefactor = planet.resourcesizelist[x] / 30
		if scalefactor < 1:
			scalefactor = 1
		#scale resource dots according to deposit size
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
		#hide them
		p.hide()
		p.position.x = planet.resourcelocationlist[x].x
		p.position.y = planet.resourcelocationlist[x].y



func _on_Tween_tween_completed(object, key):
	#if planet has already been scanned previously
	if currentplanet.resourcesscanned == true:
		#show previously revealed resource dots immediately and add totals to info panel
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
		
	