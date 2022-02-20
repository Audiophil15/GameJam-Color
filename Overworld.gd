extends Node2D

signal cutsceneEnd

# Declare member variables here. Examples:
var hvx = 0
var hvy = 0
var bvx = 0
var bvy = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Busted.visible = false
	startScene()
	
	yield(get_tree().create_timer(2),"timeout")
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$Hero.z_index = int($Hero.position.y)
#	$Bully.z_index = int($Bully.position.y)
	$Hero.position.y += hvy
	$Bully.position.x+= bvx
	$Bully.position.y+= bvy
	$MonsterBully.position.x += bvx
	$MonsterBully.position.y += bvy
	pass

func startScene():
	Sound.startOverworldMusic()
	$Hero.play("Walk (U)")
	hvy = -1
	yield(get_tree().create_timer(4),"timeout")
	hvy = 0
	$Hero.play("Idle (U)")
	$Textbox.queueText("Tom :\nTiens il n'y a personne... Je vais manger un bonbon en attendant les autres.")
	yield($Textbox, "noQueue")
	$Busted.visible = true
	$Hero.play("Idle (L)")
	$BullyComes.start()



func _on_BullyComes_timeout():
	$Busted.visible = false
	$Bully.play("Walk (R)")
	bvx = 2
	bvy = 0.15
	yield(get_tree().create_timer(4),"timeout")
	bvx = 0
	bvy = 0
	$Bully.play("Idle (R)")
	$Textbox.queueText("Jo la Racaille :\nDis moi, ça a l'air bon. Tu donnes ?")
	$Textbox.queueText("Tom :\nBen non, c'est mon goûter.")
	$Textbox.queueText("Jo la Racaille :\nEh fais pas le malin, de toute façon ici c'est moi qui décide.")
	$Textbox.queueText("Jo la Racaille :\nDonne-le-moi ou on te tabasse avec mes copains.")
	$Textbox.queueText("Tom :\nEuh, tu deviens tout vert...")
	$Textbox.queueText("Jo la Racaille :\nNe change pas de sujet.")
	$Textbox.queueText("Tom :\n(C'est drôle, cette couleur me rappelle un peu ce jeu sur la GameBoy...)")
	yield($Textbox, "noQueue")
	$Bully.visible = false
	$MonsterBully.visible = true
	yield(get_tree().create_timer(1),"timeout")
	Sound.stopOverworldMusic()
	$Bully.visible = true
	$MonsterBully.visible = false
	$Textbox.queueText("Tom :\nHein ?! Mais qu'est-ce qui se passe ici ?")
	$Textbox.queueText("Jo la Racaille :\nCe... goûter... est à moi... RAAAAAAH !!") #Inverser avec la ligne d'apres et supprimer les suivantes, ajouter un "Hein ?!?!"
	$Textbox.queueText("Jo la Racaille :\nAllez tu viens avec moi, on va retrouver mes copains !")
	yield($Textbox, "noQueue")
#	$Textbox.queueText("Tom :\nHein ???")
#	$Textbox.queueText("Tom :\nBen tu sais quoi tu as l'air déterminé, alors puisque c'est ça essaye donc de me le prendre.")
	
	emit_signal("cutsceneEnd")
	
	pass # Replace with function body.
