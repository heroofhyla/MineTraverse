extends Node2D

var levels = [
]

var level_index = -1
var current_level = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = ""
	print_debug("Checking for extra levels")
	var level_pack_dir = Directory.new()
	if level_pack_dir.open("levelpack") == OK:
		print_debug("levelpack folder exist!")
		level_pack_dir.list_dir_begin()
		while true:
			level = level_pack_dir.get_next()
			if level == "":
				break
			elif not level.begins_with("."):
				print_debug("Adding level " + level)
				levels.push_back("levelpack/" + level)
		level_pack_dir.list_dir_end()
	else:
		print_debug("No levelpack directory, moving on")
	print_debug("Loading built-in levels")
	var levels_dir = Directory.new()
	levels_dir.open("res://levels")
	print_debug(levels_dir)
	levels_dir.list_dir_begin()
	while true:
		level = levels_dir.get_next()
		if level == "":
			break
		elif not level.begins_with("."):
			print_debug("Adding level " + level)
			levels.push_back("res://levels/" + level)
	levels_dir.list_dir_end()
	print("Done")
	
	call_deferred("next_level")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_level():
	if current_level:
		current_level.queue_free()
	$UI/Banner.visible = false
	$UI/AdjacentBombCount.text = "0"
	current_level = load(levels[level_index]).instance()
	get_tree().get_root().add_child(current_level)
	
func next_level():
	level_index += 1
	start_level()
	
func reload_level():
	start_level()