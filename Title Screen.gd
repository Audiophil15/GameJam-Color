extends Control

signal play

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/Play.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_button_up():
	emit_signal("play")
	pass # Replace with function body.


func _on_Quit_button_up():
	get_tree().quit()
	pass # Replace with function body.
