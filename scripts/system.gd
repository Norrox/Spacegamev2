extends Node2D

var currentstar
var visited = false
var acceptableradiuslist = []
var backgroundchoice = null
var minimapdotlist = []
var circlelist = []
onready var landedmenu = preload("res://scenes/landedmenu.tscn")
onready var starnamelabel = get_node("/root/main/gui/starname")
onready var minimapsection = get_node("/root/main/gui/minimap/minimapsection")
onready var camera = get_node("/root/main/viewportcontainer/viewport/camera2d")
onready var redcircle = preload("res://scenes/redcircle.tscn")
onready var greencircle = preload("res://scenes/greencircle.tscn")
onready var bluecircle = preload("res://scenes/bluecircle.tscn")
var minimapcentre
onready var minimapdotwhite = preload("res://scenes/minimapdotwhite.tscn")

var baseplanetlist = []



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#put minimap rectangle of visible area in proportional position of where camera starts

func _process(delta):
	minimapsection.position.x = (camera.get_camera_screen_center().x * 0.0199)
	minimapsection.position.y = (camera.get_camera_screen_center().y * 0.0204)
	for x in baseplanetlist:
		#change lighting direction shining on planet
		var lightdirx = -0.3
		var lightdiry = 0.0
		#change position of planets on their orbits
		x.position = Vector2(x.orbitradius, 0).rotated(deg2rad(x.currentangle))
		x.currentangle += (1300 / (x.orbitradius / 1.5)) * delta
		#wrap 360 degrees back to zero
		if x.currentangle > 360:
			x.currentangle = 0
		if x.currentangle > 0 and x.currentangle < 90:
			lightdirx = lightdirx + (x.currentangle / 300)
			lightdiry = lightdiry - (x.currentangle / 300)
		elif x.currentangle > 90 and x.currentangle < 180:
			var anglenormalised = x.currentangle - 90
			lightdirx = 0
			lightdiry = -0.3
			lightdirx = lightdirx + (anglenormalised / 300)
			lightdiry = lightdiry + (anglenormalised / 300)
		elif x.currentangle > 180 and x.currentangle < 270:
			var anglenormalized = x.currentangle - 180
			lightdirx = 0.3
			lightdiry = 0
			lightdirx = lightdirx - (anglenormalized / 300)
			lightdiry = lightdiry + (anglenormalized / 300)
		else:
			var anglenormalized = x.currentangle - 270
			lightdirx = 0
			lightdiry = 0.3
			lightdirx = lightdirx - (anglenormalized / 300)
			lightdiry = lightdiry - (anglenormalized / 300)
		var mat = x.get_node("Sprite").get_material()
		#change lighting shader parameter
		mat.set_shader_param("lightDir", Vector3(lightdirx, lightdiry, 0.5))
	for x in range(0, baseplanetlist.size()):
		#change minimap dots for planets based on their updated position
		var minimapx = (baseplanetlist[x].position.x / 50) + minimapcentre.get_global_position().x
		var minimapy = (baseplanetlist[x].position.y / 50) + minimapcentre.get_global_position().y
		minimapdotlist[x].position = Vector2(minimapx, minimapy)

func _minimapdots():
	#generate minimapdots
	get_node("/root/main/gui/minimap").show()
	minimapcentre = get_node("/root/main/gui/minimapcentre")
	#change size of minimap dot for the sun based on the suns size
	var centredotscale = 0.02 * (currentstar.sunsize)
	#change colour of minimap dot based on sun type
	if currentstar.suntype == 1:
		minimapcentre.texture = load("res://art/suns/sunred.png")
	elif currentstar.suntype == 2:
	    minimapcentre.texture = load("res://art/suns/sunorange.png")
	elif currentstar.suntype == 3:
	    minimapcentre.texture = load("res://art/suns/sunyellow.png")
	elif currentstar.suntype == 4:
	    minimapcentre.texture = load("res://art/suns/sunviolet.png")
	elif currentstar.suntype == 5:
	    minimapcentre.texture = load("res://art/suns/sunblue.png")
	elif currentstar.suntype == 6:
	    minimapcentre.texture = load("res://art/suns/sunwhite.png")
	minimapcentre.scale = Vector2(centredotscale, centredotscale)
	var p
	for x in baseplanetlist:
		#circle orbits on minimap, set their color based on planet temperature
		if x.planettemperature > 240 and x.planettemperature < 333:
			p = greencircle.instance()
			circlelist.append(p)
			get_node("/root/main/").add_child(p)
		elif x.planettemperature >= 333:
			p = redcircle.instance()
			circlelist.append(p)
			get_node("/root/main/").add_child(p)
		else:
			p = bluecircle.instance()
			circlelist.append(p)
			get_node("/root/main/").add_child(p)
		var y = x.orbitradius * 0.000040
		p.global_position = minimapcentre.global_position
		p.scale = Vector2(y, y)
		#add planet dots
		var i = minimapdotwhite.instance()
		get_node("/root/main").add_child(i)
		i.scale = Vector2(0.01, 0.01)
		var minimapx = (x.position.x / 50) + minimapcentre.get_global_position().x
		var minimapy = (x.position.y / 50) + minimapcentre.get_global_position().y
		i.position = Vector2(minimapx, minimapy)
		minimapdotlist.append(i)
	#have now visited this star system
	visited = true
	
func _generatesystem(systemdict):
	#generate system, called from main
	randomize()
	#choose background
	backgroundchoice = systemdict["backgroundchoice"]
	if backgroundchoice == 1:
		get_parent().get_node("background").texture = load("res://art/background (1).png")
	elif backgroundchoice == 2:
		get_parent().get_node("background").texture = load("res://art/background (2).png")
	elif backgroundchoice == 3:
		get_parent().get_node("background").texture = load("res://art/background (3).png")
	elif backgroundchoice == 4:
		get_parent().get_node("background").texture = load("res://art/background (4).png")
	elif backgroundchoice == 5:
		get_parent().get_node("background").texture = load("res://art/background (5).png")
	elif backgroundchoice == 6:
		get_parent().get_node("background").texture = load("res://art/background (6).png")
	elif backgroundchoice == 7:
		get_parent().get_node("background").texture = load("res://art/background (7).png")
	elif backgroundchoice == 8:
		get_parent().get_node("background").texture = load("res://art/background (8).png")
	elif backgroundchoice == 9:
		get_parent().get_node("background").texture = load("res://art/background (9).png")
	elif backgroundchoice == 10:
		get_parent().get_node("background").texture = load("res://art/background (10).png")
	elif backgroundchoice == 11:
		get_parent().get_node("background").texture = load("res://art/background (11).png")
	elif backgroundchoice == 12:
		get_parent().get_node("background").texture = load("res://art/background (12).png")
	elif backgroundchoice == 13:
		get_parent().get_node("background").texture = load("res://art/background (13).png")
	elif backgroundchoice == 14:
		get_parent().get_node("background").texture = load("res://art/background (14).png")
	elif backgroundchoice == 15:
		get_parent().get_node("background").texture = load("res://art/background (15).png")
	elif backgroundchoice == 16:
		get_parent().get_node("background").texture = load("res://art/background (16).png")
	elif backgroundchoice == 17:
		get_parent().get_node("background").texture = load("res://art/background (17).png")
	elif backgroundchoice == 18:
		get_parent().get_node("background").texture = load("res://art/background (18).png")
	elif backgroundchoice == 19:
		get_parent().get_node("background").texture = load("res://art/background (19).png")
	elif backgroundchoice == 20:
		get_parent().get_node("background").texture = load("res://art/background (20).png")
	elif backgroundchoice == 21:
		get_parent().get_node("background").texture = load("res://art/background (21).png")
	#load the sun sprite
	var sunsprite = load("res://scenes/sunsprite.tscn")
	sunsprite = sunsprite.instance()
	currentstar = sunsprite
	var mat = sunsprite.get_material()
	#change shader paramters based on sun type
	if systemdict["suntype"] == 1:
		mat.set_shader_param("suncolor", Vector3(0.85, 0.15, 0.0))
		mat.set_shader_param("secondsuncolor", Vector3(0.85, 0.05, 0.0))
	elif systemdict["suntype"] == 2:
		mat.set_shader_param("suncolor", Vector3(0.82, 0.666, 0.227))
		mat.set_shader_param("secondsuncolor", Vector3(0.85, 0.35, 0))
	elif systemdict["suntype"] == 3:
		mat.set_shader_param("suncolor", Vector3(0.83, 0.82, 0.227))
		mat.set_shader_param("secondsuncolor", Vector3(0.75, 0.65, 0.1))
	elif systemdict["suntype"] == 4:
		mat.set_shader_param("suncolor", Vector3(0.83, 0.227, 0.83))
		mat.set_shader_param("secondsuncolor", Vector3(0.75, 0.4, 0.8))
	elif systemdict["suntype"] == 5:
		mat.set_shader_param("suncolor", Vector3(0.227, 0.709, 0.88))
		mat.set_shader_param("secondsuncolor", Vector3(0.1, 0.4, 0.8))
	else:
		mat.set_shader_param("suncolor", Vector3(0.8, 0.8, 0.8))
		mat.set_shader_param("secondsuncolor", Vector3(0.7, 0.7, 0.7))
	#change sprite size based on sun size
	sunsprite.scale = Vector2(systemdict["sunsize"] * 2.0, systemdict["sunsize"] * 2.0)
	# 0, 0 is centre of system
	sunsprite.position.x = 0
	sunsprite.position.y = 0
	#sprite has redundant variables from the system database
	sunsprite.suntemperature = systemdict["suntemperature"]
	sunsprite.suntype = systemdict["suntype"]
	sunsprite.sunsize = systemdict["sunsize"]
	sunsprite.sunname = systemdict["sunname"]
	sunsprite.get_node("Area2D/").gravity = systemdict["sunsize"] * 250
	
	add_child(sunsprite)
	_generateplanets(systemdict)

func _generateplanets(systemdict):
	#generate planets
	var habitableplanet = load("res://scenes/habitableplanet.tscn")
	var gasgiantplanet = load("res://scenes/gasgiantplanet.tscn")
	var nonhabitableplanet = load("res://scenes/nonhabitableplanet.tscn")
	var count = systemdict["numplanets"]
	var p
	for x in range(1, count):
		#give each planet its generated variables
		var planetname = str(systemdict["sunname"] + romannumerals(x))
		var planettemperaturestring = str(planetname + "planettemperature")
		var planettemperature = systemdict[planettemperaturestring]
		var planethabitablestring = str(planetname + "planethabitable")
		var planethabitable = systemdict[planethabitablestring]
		var orbitradiusstring = str(planetname + "orbitradius")
		var orbitradius = systemdict[orbitradiusstring]
		var rockyorgassystring = str(planetname + "rockyorgassy")
		var rockyorgassy = systemdict[rockyorgassystring]
		var planetradiusstring = str(planetname + "planetradius")
		var planetradius = systemdict[planetradiusstring]
		var seed1string = str(planetname + "seed1")
		var seed1 = systemdict[seed1string]
		var periodstring = str(planetname + "period")
		var period = systemdict[periodstring]
		var persistencestring = str(planetname + "persistence")
		var persistence = systemdict[persistencestring]
		var lacunaritystring = str(planetname + "lacunarity")
		var lacunarity = systemdict[lacunaritystring]
		var colorchoicestringR = str(planetname + "colorchoiceR")
		var colorchoicestringG = str(planetname + "colorchoiceG")
		var colorchoicestringB = str(planetname + "colorchoiceB")
		var colorchoiceR = systemdict[colorchoicestringR]
		var colorchoiceG = systemdict[colorchoicestringG]
		var colorchoiceB = systemdict[colorchoicestringB]
		var resourcelocationxliststring = str(planetname + "resourcelocationxlist")
		var resourcelocationxlist = systemdict[resourcelocationxliststring]
		var resourcelocationyliststring = str(planetname + "resourcelocationylist")
		var resourcelocationylist = systemdict[resourcelocationyliststring]
		var resourcetypeliststring = str(planetname + "resourcetypelist")
		var resourcetypelist = systemdict[resourcetypeliststring]
		var resourcesizeliststring = str(planetname + "resourcesizelist")
		var resourcesizelist = systemdict[resourcesizeliststring]
		var sealevelstring = str(planetname + "sealevel")
		var sealevel = systemdict[sealevelstring]
		var innerRstring = str(planetname + "innerR")
		var innerR = systemdict[innerRstring]
		var innerGstring = str(planetname + "innerG")
		var innerG = systemdict[innerGstring]
		var innerBstring = str(planetname + "innerB")
		var innerB = systemdict[innerBstring]
		var outerRstring = str(planetname + "outerR")
		var outerR = systemdict[outerRstring]
		var outerGstring = str(planetname + "outerG")
		var outerG = systemdict[outerGstring]
		var outerBstring = str(planetname + "outerB")
		var outerB = systemdict[outerBstring]
		var gravitystring = str(planetname + "planetgravity")
		var planetgravity = systemdict[gravitystring]
		#rocky or gas giant
		if rockyorgassy == "rocky":
			p = nonhabitableplanet.instance()
		elif rockyorgassy == "gassy":
			p = gasgiantplanet.instance()
		p.planettemperature = planettemperature
		p.planethabitable = planethabitable
		p.orbitradius = orbitradius
		p.rockyorgassy = rockyorgassy
		p.scale = Vector2(planetradius, planetradius)
		p.get_node("gravity").gravity = planetgravity * 3
		p.planetradius = planetradius
		#random point on its orbit
		p.currentangle = randi() % 360
		#set position
		p.position = Vector2(p.orbitradius, 0).rotated(deg2rad(p.currentangle))
		if p.rockyorgassy == "rocky":
			#generate noise for basic terrain texture
			var noise = p.get_node("Sprite").texture.get_noise()
			noise.seed = seed1
			noise.period = period
			noise.persistence = persistence
			noise.set_lacunarity(lacunarity)
			p.seed1 = noise.seed
			p.period = noise.period
			p.persistence = noise.persistence
			p.lacunarity = noise.get_lacunarity()
			p.gravity = planetradius * 4
			p.get_node("Sprite").set_modulate(Color(colorchoiceR, colorchoiceG, colorchoiceB))
			p.colorchoice = Color(colorchoiceR, colorchoiceG, colorchoiceB)
			#add resources to planets list of resources
			for x in range(0, resourcelocationxlist.size(), 1):
				p.resourcelocationlist.append(Vector2(resourcelocationxlist[x], resourcelocationylist[x]))
			p.resourcetypelist = resourcetypelist
			p.resourcesizelist = resourcesizelist
			p.set_name(planetname)
			p.planetname = str(systemdict["sunname"] + " " + romannumerals(x))
			add_child(p)
			var l = landedmenu.instance()
			l.currentplanet = p
			#set planet map view to same noise texture as system sphere
			var noisetex = l.get_node("Sprite").texture
			var simplenoise = noisetex.get_noise()
			simplenoise.seed = l.currentplanet.seed1
			simplenoise.period = l.currentplanet.period
			simplenoise.persistence = l.currentplanet.persistence
			simplenoise.set_lacunarity(l.currentplanet.lacunarity)
			var planetsprite = l.currentplanet.get_node("Sprite")
			var colorchoice = l.currentplanet.colorchoice
			l.get_node("Sprite").set_modulate(colorchoice)
			l.get_node("Sprite/scanline").set_modulate(Color(1, 1, 1))
			p.storedlandedscene = l
		elif p.rockyorgassy == "gassy":
			#add gas giant shader parameters
			p.seed1 = seed1
			p.sealevel = sealevel
			p.innerR = innerR
			p.innerG = innerG
			p.innerB = innerB
			p.outerR = outerR
			p.outerG = outerG
			p.outerB = outerB
			var mat = p.get_node("Sprite").get_material()
			mat.set_shader_param("seed1", seed1)
			mat.set_shader_param("sealevel", sealevel)
			mat.set_shader_param("innerR", innerR)
			mat.set_shader_param("innerG", innerG)
			mat.set_shader_param("innerB", innerB)
			mat.set_shader_param("outerR", outerR)
			mat.set_shader_param("outerG", outerG)
			mat.set_shader_param("outerB", outerB)
			add_child(p)
			p.set_name(planetname)
			p.planetname = str(systemdict["sunname"] + " " + romannumerals(x))
		baseplanetlist.append(p)
	_minimapdots()



func romannumerals(number):
	#planet naming helper function
	if number == 1:
		return "I"
	elif number == 2:
		return "II"
	elif number == 3:
		return "III"
	elif number == 4:
		return "IV"
	elif number == 5:
		return "V"
	elif number == 6:
		return "VI"
	elif number == 7:
		return "VII"
	elif number == 8:
		return "VIII"
	elif number == 9:
		return "IX"
	else:
		pass