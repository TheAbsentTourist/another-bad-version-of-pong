class_name State
extends Node

# The state this one wants to switch to next
var next_state: State

# The state machine this state belongs to
@onready var state_machine: StateMachine = get_parent()

# Sent when this state wants the machine to switch
signal transition_requested(state_name: StringName)


# Runs when the state is added to the scene tree
# Never request transmission from _ready(), signal has not connected yet.
func _ready() -> void:
	pass


# Called when the state machine switches into this state
func enter() -> void:
	pass


# Called when the state machine switches out of this state
func exit() -> void:
	pass


# Called every frame while this state is the active one
func _process(_delta: float) -> void:
	pass


# Asks the state machine to switch to a state by name
func request_transition(state_name: StringName) -> void:
	transition_requested.emit(state_name)
