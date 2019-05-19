extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 120
var input_motion = Vector2(0,0)
var zero = Vector2(0,0)
var moving = false
var motion_this_frame = null
var move_delta = Vector2(0,0)
var move_direction = Vector2(0,0)
var move_this_turn = Vector2(0,0)
var dead = false
var win = false
var lock_controls = false
onready var bomb_count_field = get_node("/root/Game/UI/AdjacentBombCount")
onready var banner_label = get_node("/root/Game/UI/Banner")
onready var game = get_node("/root/Game");
var input_mapping = {
	"move_left": Vector2(-1,0),
	"move_right": Vector2(1,0),
	"move_up": Vector2(0,-1),
	"move_down": Vector2(0,1),
	}
var adjacent_bomb_count = 0
var input_keys = input_mapping.keys()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if dead:
		if Input.is_action_just_pressed("ui_accept"):
			game.reload_level()
		return

	if win:
		if Input.is_action_just_pressed("ui_accept"):
			game.next_level()
		return

	input_motion = zero
	if not lock_controls:
		for input in input_keys:
			if Input.is_action_pressed(input):
				input_motion += input_mapping[input]
				break

	if moving:
		move_this_turn = move_and_slide(speed * move_direction) * delta
		move_delta += move_this_turn
		if move_delta.length() >= 24 or move_this_turn == zero:
			if input_motion == zero:
				position.x = (int(position.x + .5) / 24) * 24 + 12
				position.y = (int(position.y + .5) / 24) * 24 + 12
				moving = false
				move_delta = zero
			else:
				move_direction = input_motion
				if move_direction.x == 0:
					position.x = (int(position.x + .5) / 24) * 24 + 12
					move_delta.x = 0
					move_delta.y -= max(0, abs(move_delta.y)) * sign(move_delta.y)
				else:
					position.y = (int(position.y + .5) / 24) * 24 + 12
					move_delta.x -= max(0, abs(move_delta.x)) * sign(move_delta.x)
					move_delta.y = 0
	else:
		if adjacent_bomb_count == -1:
			adjacent_bomb_count = len($DetectArea.get_overlapping_areas())
			bomb_count_field.text = str(adjacent_bomb_count)

		if input_motion != zero:
			move_and_slide(speed * input_motion)
			move_direction = input_motion
			adjacent_bomb_count = -1
			bomb_count_field.text = "?"
			moving = true;
	

func _on_TouchArea_area_entered(area):
	if area.is_in_group("Bomb"):
		lock_controls = true
		area.trigger()
		$DeathTimer.start(.3)
	elif area.is_in_group("Goal"):
		lock_controls = true
		$WinTimer.start(.5)
		


func _on_DeathTimer_timeout():
	banner_label.visible = true
	banner_label.text = "GAME OVER\nPress ENTER to retry"
	print_debug("YOU DIED")
	dead = true
	$Sprite.visible = false

func _on_WinTimer_timeout():
	win = true
	banner_label.visible = true
	banner_label.text = "YOU WIN!\nPress ENTER to continue"
	for bomb in get_tree().get_nodes_in_group("Bomb"):
		bomb.reveal()