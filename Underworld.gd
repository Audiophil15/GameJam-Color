extends Node2D

signal closeScene

# Declare member variables here. Examples:
var Possessed = preload("res://Possessed.tscn")
var Slime = preload("res://Slime.tscn")
var Skelet = preload("res://Skeleton.tscn")
var spawnPos=[Vector2(960,310), Vector2(1408,310), Vector2(512, 310)]
var spawnedMobs = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawner.wait_time = 3
	$Spawner.start()
	$MusicDelay.start()
	$Player.connect("dead", self, "playerCouic")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Spawner_timeout():
	var mobPos = spawnPos[randi()%len(spawnPos)]
	var mobType = randi()%3
	var mob
	if mobType == 0 :
		mob = Possessed.instance()
	if mobType == 1 :
		mob = Slime.instance()
	if mobType == 2 :
		mob = Skelet.instance()
	mob.position = mobPos
	add_child(mob)
	spawnedMobs += 1
	if $Spawner.wait_time>0.5 :
		$Spawner.wait_time -= 0.2*spawnedMobs
	pass # Replace with function body.


func _on_MusicDelay_timeout():
	Sound.startUnderworldMusic()
	pass # Replace with function body.

func playerCouic():
	emit_signal("closeScene")