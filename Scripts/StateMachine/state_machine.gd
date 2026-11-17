class_name StateMachine
extends Node

# The body this state machine is controlling
@onready var body: CharacterBody2D = get_parent()

# The state the machine starts in
@export var initial_state: State

# The state currently running
var current_state: State
# The state the machine is switching toward
var target_state: State

# Every child state, stored by its node name
var states: Dictionary = {}

# Initialization
func _ready() -> void:
	# Finds every child state, disables it, and stores it
	_get_states()
	# Connects each state's transition signal to the machine
	for state in states.values():
		if state is State:
			state.transition_requested.connect(on_transition_requested)
	
	# Waits until the owner is ready so the scene is fully set up
	await owner.ready
	# Keep at very end of _ready()
	_change_state(initial_state)


# Finds child states, turns them off, and stores them by name
func _get_states() -> void:
	for child in get_children():
		if child is State:
			# Turns the state off until the machine activates it
			child.process_mode = Node.PROCESS_MODE_DISABLED
			states[child.name] = child


# Switches to the state a child asked for
func on_transition_requested(state_name: StringName) -> void:
	# Looks up the requested state by name
	var next: State = states.get(state_name)
	# Pushes an error if that state does not exist
	if next == null:
		push_error("State not found: %s" % state_name)
		return
	_change_state(next)


# Leaves the current state and enters the next one
func _change_state(next: State) -> void:
	if current_state:
		current_state.exit()
		# Turns the old state off so it stops processing
		current_state.process_mode = Node.PROCESS_MODE_DISABLED
	current_state = next
	# Turns the new state on so its _process runs
	current_state.process_mode = Node.PROCESS_MODE_INHERIT
	current_state.enter()
