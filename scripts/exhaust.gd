extends Line2D

var target
var point
var pointx
var pointy
export(NodePath) var targetPath
var traillength = 0
var xmodifier = 0
var ymodifier = 0
var randx
var randy

func _ready():
	#the exhaust starts at a point behind ship, set it here
	target = get_node(targetPath)
	randomize()
	
func _process(delta):
	#variable exhaust length depending on engine/ship
	traillength = get_parent().exhaust_length
	global_position = Vector2(0, 0)
	global_rotation = 0
	#randomise pixel stream slightly to give jagged fiery effect
	randx = randi() % 2
	randy = randi() % 2
	if randx == 0:
		xmodifier = -1
	elif randx == 1:
		xmodifier = 0
	elif randx == 2:
		xmodifier = 1
	if randy == 0:
		ymodifier = -1
	elif randy == 1:
		ymodifier = 0
	elif randy == 2:
		ymodifier = 1
	pointx = target.global_position.x + xmodifier
	pointy = target.global_position.y + ymodifier
	point = Vector2(pointx, pointy)
	add_point(point)
	#don't let go over max allowed length
	while get_point_count() > traillength:
		remove_point(0)