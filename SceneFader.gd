extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shader_fade_out(rootnode):
	var fadeout = $Tween
	fadeout.interpolate_property(rootnode, "modulate", Color(1,1,1), Color(0,0,0), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	fadeout.start()

func shader_fade_in(rootnode):
	var fadeout = $Tween
	fadeout.interpolate_property(rootnode, "modulate", Color(0,0,0), Color(1,1,1), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	fadeout.start()
