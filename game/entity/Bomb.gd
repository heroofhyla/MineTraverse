extends Area2D

onready var sfx_player = get_node("/root/Game/ExplosionPlayer")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func trigger():
	$ExplodeTimer.start(.3)
	$Sprite.visible = true

func reveal():
	$Sprite.visible = true

func _on_ExplodeTimer_timeout():
	sfx_player.play()
	$ExplosionSprite.visible = true
	pass # Replace with function body.
