extends Node


var minVol = -40
var inGameNode
var time

# Called when the node enters the scene tree for the first time.
func _ready():
	var path = "Music/In Game "+str(randi()%9)
	inGameNode = get_node(path)
	pass # Replace with function body.

func startMusic(musicNode, fade = 1):
	musicNode.play()
	if fade :
		fadein(musicNode)

func playEffect(effectNode):
	effectNode.play()

func stopMusic(musicNode, fade = 1):
	if fade :
		fadeout(musicNode)
		yield(get_tree().create_timer(1.5),"timeout")
	musicNode.stop()

func fadein(audioNode, from = minVol, to = 0, time = 0.4) :
	var fadein = $Tween
	fadein.interpolate_property(audioNode, "volume_db", from, to, time)
	fadein.start()

func fadeout(audioNode, time = 2):
	var fadeout = $Tween
	fadeout.interpolate_property(audioNode, "volume_db", audioNode.volume_db, minVol, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fadeout.start()



func startTitle():
	startMusic($Music/Title)

func stopTitle():
	stopMusic($Music/Title, 0)
	
func startOverworldMusic():
	startMusic($Music/Cutscene, 0)
	
func stopOverworldMusic():
	stopMusic($Music/Cutscene, 1)
	
func startUnderworldMusic():
	startMusic(inGameNode, 0)

func stopUnderworldMusic():
	stopMusic(inGameNode, 1)
	


func loseEffect():
	playEffect($Effect/Lost)

func winEffect():
	playEffect($Effect/Win)

func deathEffect():
	playEffect($Effect/Death)
	
func hurtEffect():
	playEffect($Effect/Hurt)
	
func hitEffect():
	playEffect($Effect/Hit)
func pauseSet():
	playEffect($"Effect/Menu Select")
	time = inGameNode.get_playback_position()
	inGameNode.stop()
	
func pauseUnset():
	playEffect($"Effect/Menu Select 2")
	inGameNode.play()
	inGameNode.seek(time)
