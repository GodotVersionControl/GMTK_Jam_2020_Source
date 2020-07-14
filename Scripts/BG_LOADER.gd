extends Control

const SIMULATED_DELAY_SEC = 0
var thread = null

var allowed_to_load = false


func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	# Call deferred to configure max load steps.
	var res = null
	
	while true: #iterate until we have a resource
		
		# Simulate a delay.
		OS.delay_msec(int(SIMULATED_DELAY_SEC * 1000.0))
		# Poll (does a load step).
		var err = ril.poll()
		# If OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if err == ERR_FILE_EOF:
			# Loading done, fetch resource.
			res = ril.get_resource()
			print("Scene > " + path + " < loaded to memory")
			if not allowed_to_load:
				print("Waiting for permission to load in")
			break
		elif err != OK:
			# Not OK, there was an error.
			print("There was an error while loading scene > " + path + " < to memory")
			break
	
	# Waits for permission to load the new scene
	while true:
		if allowed_to_load:
			print("Scene > " + path + " < loaded in succesfuly")
			allowed_to_load = false
			break
	
	# Send whathever we did (or did not) get.
	call_deferred("_thread_done", res)


func _thread_done(resource):
	assert(resource)
	# Always wait for threads to finish, this is required on Windows.
	thread.wait_to_finish()

	# Instantiate new scene.
	var new_scene = resource.instance()
	# Free current scene.
	get_tree().current_scene.queue_free()
	get_tree().current_scene = null
	# Add new one to root.
	get_tree().root.add_child(new_scene)
	# Set as current scene.
	get_tree().current_scene = new_scene


# Starts loading
func load_scene(path):
	thread = Thread.new()
	thread.start(self, "_thread_load", path)
	raise() # Show on top.


# Allows to load the new scene
func load_when_ready():
	allowed_to_load = true
