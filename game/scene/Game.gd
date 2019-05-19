extends Node2D

var levels = [
	"Level01",
	"Level02",
	"TheEnd"
]

var level_index = -1
var current_level = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("next_level")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_level():
	if current_level:
		current_level.queue_free()
	$UI/Banner.visible = false
	current_level = load("res://levels/" + levels[level_index] + ".tscn").instance()
	get_tree().get_root().add_child(current_level)
	
func next_level():
	level_index += 1
	start_level()
	
func reload_level():
	start_level()