extends Node

## https://www.reddit.com/r/godot/comments/13u9w0j/comment/ldb4q0w
static func load_asset(path : String) -> Resource:
	if OS.has_feature("export"):
		# Check if file is .remap
		if not path.ends_with(".remap"):
			return load(path)

		# Open the file
		var __config_file = ConfigFile.new()
		__config_file.load(path)

		# Load the remapped file
		var __remapped_file_path: String = __config_file.get_value("remap", "path")
		__config_file = null
		return load(__remapped_file_path)
	else:
		return load(path)

func load_folder(folder: String) -> Array:
	var o = []
	for file in DirAccess.open("res://resources/" + folder).get_files():
		if file.ends_with(".tres") or file.ends_with(".res"):
			o.push_back(load_asset("res://resources/" + folder + "/" + file))
	return o

@onready var enemies = load_folder("enemy")
@onready var mechs = load_folder("mechs/mechs")
