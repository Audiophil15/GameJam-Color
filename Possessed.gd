extends KinematicBody2D


# Declare member variables here. Examples:
var maxLife = 20
var life = maxLife
var damages = 13
var dead = false
var speed = Vector2()
var speedfactor = 150
var followingPlayer = false
var attackAnimPlaying = false
var nextToPlayer = false
var ishurt = false
onready var animations = $AnimationPlayer
var playerBodyID
var direction = "D"
var animHurtName
var animAttackName
var animIdleName
var animDeathName
var animRunningName

# Called when the node enters the scene tree for the first time.
func _ready():
	playerBodyID = $"/root/PlayerGlobal".playerBody
	$"/root/EnemiesGlobal".enemiesHitboxes.push_back($Attack.get_instance_id())
	$"/root/EnemiesGlobal".enemiesDamages.push_back(damages)
	updateDirection()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z_index = int(position.y)
	if life <= 0 :
		death()
	if not ishurt :
		move()
		updateDirection()
		updateAnimation()

func move():
	if followingPlayer and !attackAnimPlaying:
		speed = ($"/root/PlayerGlobal".playerPosition - position).normalized()
	else :
		speed = Vector2()
	speed *= speedfactor
	move_and_slide(speed)
#	position.x += speed.x*speedfactor
#	position.y += speed.y*speedfactor
	
func updateAnimation():
	if attackAnimPlaying :
		animations.play(animAttackName)
#	elif ishurt :
#		animations.play(animHurtName)
	else :
		if (speed.length()==0):
			animations.play(animIdleName)
		else :
			animations.play(animRunningName)


func updateDirection():
	if abs(speed.x) > abs(speed.y):
		if speed.x<0 :
			direction = "L"
		if speed.x>0 :
			direction = "R"
	if abs(speed.x) < abs(speed.y):
		if speed.y<0 :
			direction = "U"
		if speed.y>0 :
			direction = "D"
	animAttackName = "Attacking ("+direction+")"
	animHurtName = "Hurt ("+direction+")"
	animIdleName = "Idle ("+direction+")"
	animDeathName = "Death ("+direction+")"
	animRunningName = "Running ("+direction+")"

func attack():
	attackAnimPlaying = true

func getHit():
	ishurt = true
	animations.play(animHurtName)
	Sound.hitEffect()
	life -= 6

func death():
	if !dead:
		$"/root/EnemiesGlobal".killedEnemies += 1
		dead = true
	animations.play(animDeathName)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == animHurtName:
		ishurt = false
	if anim_name == animAttackName and !nextToPlayer:
		attackAnimPlaying = false
	if anim_name == animDeathName :
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
