extends Node

var preScript = preload("res://softnoise.gd")
var softnoise
var coordarray = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Random
	softnoise = preScript.SoftNoise.new()
	#Passing a seed
	#softnoise = preScript.SoftNoise.new(1729)
	
	#softnoise.simple_noise1d(x)
	#softnoise.simple_noise2d(x, y)
	
	#softnoise.value_noise2d(x, y)
	#softnoise.perlin_noise2d(x, y)
	
	softnoise.openSimplex2D(x, y)
	#softnoise.openSimplex3D(x, y, z)
	#softnoise.openSimplex4D(x, y, z, w)