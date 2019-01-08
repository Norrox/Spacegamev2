extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _universeviewmode():
	$minimap.hide()
	if has_node("minimapcentre"):
		$minimapcentre.hide()
	

func _systemviewmode():
	$minimap/minimapsection/minimapsectionbox.show()
	$minimap.z_index = 0
	$planetname.text = ""
	$planettemp.text = ""
	var planetguiboxes = get_tree().get_nodes_in_group("planettext")
	for x in planetguiboxes:
		x.hide()

func _planetviewmode(planetchoice):
	$minimap/minimapsection/minimapsectionbox.hide()
	var currentplanet = planetchoice.get_parent().get_parent()
	var planetsprite = currentplanet.get_node("Sprite")
	$scan.show()
	$land.show()
	$leave.show()
	#set menu selection to default, set info boxes to default
	$scan.color = Color(0.2, 0.3, 0.37)
	$land.color = Color(0.03, 0.03, 0.03)
	$leave.color = Color(0.03, 0.03, 0.03)
	var planetguiboxes = get_tree().get_nodes_in_group("planettext")
	for x in planetguiboxes:
		x.show()
	$common.text = "Common : "
	$metals.text = "Metal : "
	$uncommon.text = "Uncommon : "
	$precious.text = "Precious : "
	$radioactive.text = "Radioactive : "
	$exotic.text = "Exotic : "
	$planetname.text = str(planetchoice.get_parent().get_parent().planetname)
	$planettemp.text = "Temp: " + str(int(planetchoice.get_parent().get_parent().planettemperature)) + " K / " + str(int(planetchoice.get_parent().get_parent().planettemperature) - 273) + " C"
	#create a view of the planet sprite sphere in bottom right
	var globeview = planetsprite.duplicate(8)
	var globesize = globeview.texture.get_size()
	if globesize.x > 200 or globesize.y > 125:
		globeview.scale = Vector2(globeview.scale.x * 0.45, globeview.scale.y * 0.45)
	get_node("/root/main/").add_child(globeview)
	globeview.name = "globeview"
	globeview.global_position = get_node("/root/main/gui/minimapcentre/").global_position
	$minimap.z_index = 6
	globeview.z_index = 10

func _combatviewmode():
	pass