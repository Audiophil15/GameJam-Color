extends Control

var isPaused = false setget setPause

func _input(event):
	if event.is_action_pressed("ui_pause"):
		setPause(!isPaused)

func setPause(val):
	isPaused = val
	get_tree().paused = isPaused
	visible = isPaused
	if isPaused :
		Sound.pauseSet()
	else :
		Sound.pauseUnset()
	$CenterContainer/Node2D/VBoxContainer/Resume.grab_focus()

## Called when the node enters the scene tree for the first time.
func _ready():
#	setPause(false)
	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _unhandled_input(event):
#	if event.is_action_pressed("ui_pause") :
#		self.isPaused = !isPaused
#
func _on_Resume_button_up():
	setPause(false)
	pass # Replace with function body.

func _on_Quit_button_up():
	get_tree().quit()
	pass # Replace with function body.
