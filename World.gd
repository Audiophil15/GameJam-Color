extends Control

var cutscene = preload("res://Overworld.tscn")
var Underworld = preload("res://Underworld.tscn")
var Title = preload("res://Title Screen.tscn")

enum Scene {
	TITLE,
	OVERWORLD,
	UNDERWORLD
}

var curScene = Scene.TITLE

# Called when the node enters the scene tree for the first time.
func _ready():
	toTitle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(str($Tree.z_index)+str($Player.z_index))

func toTitle():
	if curScene == Scene.UNDERWORLD :
		SceneFader.shader_fade_out($"Underworld")
		$"Underworld".queue_free()
		get_node("/root/World").remove_child($"Underworld")
	curScene = Scene.TITLE
	var title = Title.instance()
	get_node("/root/World").add_child(title)
	title.set_name("Title Screen")
	Sound.startTitle()
	$"Title Screen".connect("play", self, "toCutscene")
	SceneFader.shader_fade_in($"Title Screen")

func toCutscene():
	Sound.stopTitle()
	SceneFader.shader_fade_out($"Title Screen")
	var overworld = cutscene.instance()
	$"Title Screen".queue_free()
	get_node("/root/World").remove_child($"Title Screen")
	get_node("/root/World").add_child(overworld)
	overworld.set_name("Overworld")
	$Overworld.connect("cutsceneEnd", self, "toUnderworld")
	curScene = Scene.OVERWORLD
	SceneFader.shader_fade_in($Overworld)

func toUnderworld():
	$Textbox.queueText("Tom :\nHein ???")
	SceneFader.shader_fade_out($Overworld)
	$Textbox.queueText("Tom :\nC'est comme dans mon jeuuu !!!")
	var underworld = Underworld.instance()
	yield($Textbox, "noQueue")
	get_node("/root/World").add_child(underworld)
	underworld.set_name("Underworld")
	$Underworld.connect("closeScene", self, "toTitle")
	$Overworld.queue_free()
	curScene = Scene.UNDERWORLD
	get_node("/root/World").remove_child($Overworld)
	SceneFader.shader_fade_in($Underworld)
	
