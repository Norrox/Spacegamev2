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
	target = get_node(targetPath)
	randomize()
	
func _process(delta):
	traillength = get_parent().exhaust_length
	global_position = Vector2(0, 0)
	global_rotation = 0
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
	while get_point_count() > traillength:
		remove_point(0)