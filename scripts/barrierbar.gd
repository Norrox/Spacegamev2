extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_solarsystem_combat_signal():
	$CollisionShape2D.disabled = true


func _on_solarsystem_leave_combat():
	$CollisionShape2D.disabled = false
