extends KinematicBody2D


# Declare member variables here. Examples:
var maxLife = 20
var life = maxLife
var speed = Vector2()
var speedfactor = 150
var damages = 21
var dead = false
var followingPlayer = false
var attackAnimPlaying = false
var nextToPlayer = false
var isHit = false
onready var animations = $AnimationPlayer
var playerBodyID

# Called when the node enters the scene tree for the first time.
func _ready():
	playerBodyID = $"/root/PlayerGlobal".playerBody
	$"/root/EnemiesGlobal".enemiesHitboxes.push_back($Attack.get_instance_id())
	$"/root/EnemiesGlobal".enemiesDamages.push_back(damages)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z_index = int(position.y)
	if life <= 0 :
		death()
	if not isHit :
		move()
		updateAnimation()

func move():
	if followingPlayer and !attackAnimPlaying :
		speed = ($"/root/PlayerGlobal".playerPosition - position).normalized()
	else :
		speed = Vector2()
	speed *= speedfactor
	move_and_slide(speed)
#	position.x += speed.x*speedfactor
#	position.y += speed.y*speedfactor
	
func updateAnimation():
	if attackAnimPlaying :
		animations.play("Attacking")
	else :
		if (speed.length()==0):
			animations.play("Idle")
		else :
			animations.play("Running")
	if speed.x<0 :
		$Sprite.flip_h=true
	if speed.x>0 :
		$Sprite.flip_h=false

func attack():
	attackAnimPlaying = true

func getHit():
	isHit = true
	animations.play("Hit")
	Sound.hitEffect()
	life -= 6

func death():
	if !dead:
		$"/root/EnemiesGlobal".killedEnemies += 1
		dead = true
	animations.play("Death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		isHit = false
	if anim_name == "Attacking" and !nextToPlayer:
		attackAnimPlaying = false
	if anim_name == "Death" :
		self.queue_free()
	pass # Replace with function body.

func _on_Search_body_entered(body):
	if body.get_instance_id() == playerBodyID :
		followingPlayer = true
	pass # Replace with function body.

func _on_Search_body_exited(body):
	if body.get_instance_id() == playerBodyID :
		followingPlayer = false
	pass # Replace with function body.

func _on_Body_area_shape_entered(area_id, area, area_shape, local_shape):
	if (area_id==$"/root/PlayerGlobal".playerHitboxes) :
		getHit()
	pass # Replace with function body.

func _on_Body_body_entered(body):
	if (body.get_instance_id()==$"/root/PlayerGlobal".playerBody) :
		attack()
		nextToPlayer = true
	pass # Replace with function body.

func _on_Body_body_exited(body):
	if (body.get_instance_id()==$"/root/PlayerGlobal".playerBody) :
		nextToPlayer = false
	pass # Replace with function body.
