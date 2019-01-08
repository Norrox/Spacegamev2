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
	if has_node("globeview"):
		$globeview.queue_free()
	$ColorRect.hide()
	$planetname.text = ""
	$planettemp.text = ""
	var planetguiboxes = get_tree().get_nodes_in_group("planettext")
	for x in planetguiboxes:
		x.hide()
	
	

func _planetviewmode(planetchoice):
	var currentplanet = planetchoice.get_parent().get_parent()
	var planetsprite = currentplanet.get_node("Sprite")
	$scan.show()
	$land.show()
	$leave.show()
	$planetname.text = str(planetchoice.get_parent().get_parent().planetname)
	$planettemp.text = "Temp: " + str(int(planetchoice.get_parent().get_parent().planettemperature)) + " K / " + str(int(planetchoice.get_parent().get_parent().planettemperature) - 273) + " C"
	#create a view of the planet sprite sphere in bottom right
	var globeview = planetsprite.duplicate()
	globeview.global_position = Vector2(1200, 635)
	var globesize = globeview.texture.get_size()
	if globesize.x > 200 or globesize.y > 125:
		globeview.scale = Vector2(globeview.scale.x * 0.45, globeview.scale.y * 0.45)
	globeview.z_index = 2
	$ColorRect.show()
	add_child(globeview)

func _combatviewmode():
	pass