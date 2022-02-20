extends CanvasLayer

signal noQueue

# Declare member variables here. Examples:
const printSpeed = 0.05
onready var text = $MarginContainer/MarginContainer/HBoxContainer/Label

enum State {
	READY,
	READING,
	FINISHED
}

var currentState = State.READY
var textQueue = []
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
#	queueText("First text")
#	queueText("Second text")
#	queueText("Third text")
#	queueText("Fourth text, veeeery long to test again with the textbox width aaaah I don't know what to write")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState :
		State.READY :
			if !textQueue.empty() :
				displayText()
		State.READING :
			if text.percent_visible==1.0 or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel") :
				text.percent_visible = 1.0
				$Tween.remove_all()
				changeState(State.FINISHED)
		State.FINISHED :
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel") :
				if textQueue.empty():
					hide()
					emit_signal("noQueue")
				changeState(State.READY)
	pass

func hide():
	text.text = ""
	$MarginContainer.hide()
	
func show():
	$MarginContainer.show()

func queueText(text):
	textQueue.push_back(text)

func displayText():
	var newText = textQueue.pop_front()
	text.percent_visible = 0.0
	text.text = newText
	changeState(State.READING)
	show()
	$Tween.interpolate_property(text, "percent_visible", 0.0, 1.0, len(newText)*printSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func changeState(newState):
	currentState = newState
	
func state():
	return currentState

func emptyQueue():
	return textQueue.empty()
