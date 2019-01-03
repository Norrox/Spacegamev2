extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_pointer_area_entered(area):
	get_parent()._highlightsystem(area.get_parent().get_global_position(), area.get_parent().name)
	get_parent().highlightedstar = area.get_parent()


func _on_pointer_area_exited(area):
	get_parent()._unhighlightsystem()
	get_parent().highlightedstar = null
