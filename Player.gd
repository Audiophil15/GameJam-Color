extends KinematicBody2D

signal dead

# Declare member variables here. Examples:
var maxlife = 50
var life = maxlife
var speed = Vector2()
var speedfactor = 500
var dashfactor = 1
var ishurt = false
var isdead = false
var attackAnimPlaying=0
onready var animations = $AnimationPlayer
var direction = "D"
var animHurtName
var animAttackName
var animIdleName
var animDeathName
var animRunningName
var screenSize

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/PlayerGlobal".playerBody = self.get_instance_id()
	$"/root/PlayerGlobal".playerHitboxes = $Attack.get_instance_id()
	screenSize = get_viewport_rect().size
	updateDirection()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z_index = int(position.y)
	if life>0 and not ishurt :
		getInput()
		updateDirection()
		move()
		$"/root/PlayerGlobal".playerPosition = position
	
	updateAnimation()

func getInput():
	if (Input.is_action_pressed("attack_1")):
		attack(1)
	if (Input.is_action_pressed("attack_2")):
		attack(2)
	if (Input.is_action_pressed("dash")):
		attack(3)
		
	if attackAnimPlaying == 3:
		dashfactor = 2
#		collision_layer = 2
#		collision_mask = 2
		$CollisionBox.disabled = true
	else :
#		collision_layer = 3
#		collision_mask = 3
		dashfactor = 1
		$CollisionBox.disabled = false
		speed = Vector2()
	
	if attackAnimPlaying == 0:
		
		if (Input.is_action_pressed("ui_left")) :
			speed.x -= 1
		if (Input.is_action_pressed("ui_right")) :
			speed.x += 1
		if (Input.is_action_pressed("ui_up")) :
			speed.y -= 1
		if (Input.is_action_pressed("ui_down")) :
			speed.y += 1

	speed = speed.normalized()
	
	

func move():
	speed *= speedfactor * dashfactor
	move_and_slide(speed)
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	
func updateAnimation():
	if attackAnimPlaying :
		animations.play(animAttackName)
	elif ishurt :
		animations.play(animHurtName)
	elif isdead :
		animations.play(animDeathName)
	else :
		if (speed.length()==0):
			animations.play(animIdleName)
		else :
			animations.play(animRunningName)
		
func updateDirection():
	if attackAnimPlaying == 0 :
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
 
	animAttackName = "Attacking "+str(attackAnimPlaying)+" ("+direction+")"
	animHurtName = "Hurt ("+direction+")"
	animIdleName = "Idle ("+direction+")"
	animDeathName = "Death ("+direction+")"
	animRunningName = "Running ("+direction+")"
	
func attack(num):
	attackAnimPlaying = num
	
func getHit():
	ishurt = true
	animations.play(animHurtName)
	Sound.hurtEffect()

func death():
	isdead = true
	$CollisionBox.disabled = true
	$Body/CollisionShape2D.disabled = true
	Sound.deathEffect()
	Sound.loseEffect()
	animations.play(animDeathName)
	emit_signal("dead")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == animHurtName:
		ishurt = false
		if life <= 0 :
			death()
	if anim_name == animAttackName:
		attackAnimPlaying = 0
	if anim_name == animDeathName :
		self.queue_free()

func _on_Body_area_shape_entered(area_id, area, area_shape, local_shape):
	var index = $"/root/EnemiesGlobal".enemiesHitboxes.find(area_id)
	if index != -1 :
		getHit()
		life -= $"/root/EnemiesGlobal".enemiesDamages[index]
	pass # Replace with function body.
