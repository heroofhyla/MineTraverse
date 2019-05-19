extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 70
var input_motion = Vector2(0,0)
var zero = Vector2(0,0)
var moving = false
var motion_this_frame = null
var move_delta = Vector2(0,0)
var move_direction = Vector2(0,0)
var move_this_turn = Vector2(0,0)
var input_mapping = {
	"move_left": Vector2(-1,0),
	"move_right": Vector2(1,0),
	"move_up": Vector2(0,-1),
	"move_down": Vector2(0,1),
	}

var input_keys = input_mapping.keys()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	input_motion = zero
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
				
				
	
	elif input_motion != zero:
		move_and_slide(speed * input_motion)
		move_direction = input_motion
		moving = true;
	