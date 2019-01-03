extends Node2D

onready var sundotwhite = preload("res://scenes/mapdots/sundotwhite.tscn")
onready var starnamelabel = get_parent().get_parent().get_parent().get_node("gui/starname")
onready var coordlabel = get_parent().get_parent().get_parent().get_node("gui/coords")
onready var pointer = $pointer
var mousesystem = null
var pointerspeed = 1
var holdmovement = 0
var highlightedstar = null
var numstars = 5
var redstar = Color(214, 4, 4)
var bluestar = Color(4, 114, 214)
var whitestar = Color(255, 255, 255)
var yellowstar = Color(215, 222, 7)
var violetstar = Color(220, 6, 220)
var orangestar = Color(220, 90, 7)
var p
var starlist = []

func _ready():
	randomize()
	var xstring = var2str(int(pointer.position.x))
	var ystring = var2str(int(pointer.position.y))
	coordlabel.set_text(xstring + ", " + ystring)

func _populateuniversescene():
	var universefile = File.new()
	universefile.open("res://systemdata/universe.json", File.READ)
	while not universefile.eof_reached():
		if parse_json(universefile.get_line()) == null:
			return
		p = sundotwhite.instance()
		var colorchoice = Color(255, 255, 255)
		var current_line = parse_json(universefile.get_line())
		p.suntype = current_line["suntype"]
		p.sunsize = current_line["sunsize"]
		if current_line["suntype"] == 1:
			colorchoice = Color.red
		elif current_line["suntype"] == 2:
			colorchoice = Color.orange
		elif current_line["suntype"] == 3:
			colorchoice = Color.yellow
		elif current_line["suntype"] == 4:
			colorchoice = Color.violet
		elif current_line["suntype"] == 5:
			colorchoice = Color.skyblue
		elif current_line["suntype"] == 6:
			colorchoice = Color.white
		p.set_modulate(colorchoice)
		p.systemdict = current_line
		p.position = Vector2(current_line["sunpositionx"], current_line["sunpositiony"])
		p.sunname = current_line["sunname"]
		p.suntemperature = current_line["suntemperature"]
		p.scale = Vector2(0.006 * current_line["sunsize"], 0.006 * current_line["sunsize"])
		add_child(p)
	universefile.close()

func _input(event):
   # Mouse in viewport coordinates
	if event is InputEventMouseButton and event.is_pressed() and not event.is_echo():
		if get_global_mouse_position().x < 0 or get_global_mouse_position().y < 0:
			return
		else:
			pointer.global_position = get_global_mouse_position()
			if mousesystem != null:
				_highlightsystem(mousesystem.global_position, mousesystem.sunname)
		var xstring = var2str(pointer.position.x)
		var ystring = var2str(pointer.position.y)
		coordlabel.set_text(xstring + ", " + ystring)
	if event.is_action("ui_accept") and event.is_pressed() and not event.is_echo():
		if highlightedstar == null:
			return
		else:
			coordlabel.set_text("")
			get_node("/root/main")._generatesolarsystem(highlightedstar)

func _highlightsystem(position, name):
	pointer.position = position
	starnamelabel.set_text(name)
	holdmovement = 10


func _unhighlightsystem():
	starnamelabel.set_text("")

func _process(delta):
	if holdmovement > 0:
		holdmovement -= 1


func _physics_process(delta):
	if holdmovement == 0:
		if Input.is_action_pressed("ui_left"):
			if pointer.position.x < 0:
				return
			else:
				_movepointer(Vector2(-pointerspeed, 0))
		if Input.is_action_pressed("ui_right"):
			if pointer.position.x > 10000:
				return
			else:
				_movepointer(Vector2(pointerspeed, 0))
		if Input.is_action_pressed("ui_up"):
			if pointer.position.y < 0:
				return
			else:
				_movepointer(Vector2(0, -pointerspeed))
		if Input.is_action_pressed("ui_down"):
			if pointer.position.y > 10000:
				return
			else:
				_movepointer(Vector2(0, pointerspeed))
		if Input.is_action_pressed("fastleft"):
			if pointer.position.x < 0:
				return
			else:
				_movepointer(Vector2((-pointerspeed) - 2, 0))
		if Input.is_action_pressed("fastright"):
			if pointer.position.x > 10000:
				return
			else:
				_movepointer(Vector2(pointerspeed + 2, 0))
		if Input.is_action_pressed("fastup"):
			if pointer.position.y < 0:
				return
			else:
				_movepointer(Vector2(0, (-pointerspeed) - 2))
		if Input.is_action_pressed("fastdown"):
			if pointer.position.y > 10000:
				return
			else:
				_movepointer(Vector2(0, pointerspeed + 0))
			
func _movepointer(direction):
	get_node("/root/main").camerafollow = 1
	pointer.position += direction
	var xstring = var2str(int(pointer.global_position.x))
	var ystring = var2str(int(pointer.global_position.y))
	coordlabel.set_text(xstring + ", " + ystring)
	


func _on_pointer_area_entered(area):
	highlightedstar = area.get_parent()
	_highlightsystem(area.global_position, area.get_parent().sunname)


func _on_pointer_area_exited(area):
	highlightedstar = null
	_unhighlightsystem()

func _mousehoversystem(area):
	mousesystem = area

func _mouseleavesystem():
	mousesystem = null