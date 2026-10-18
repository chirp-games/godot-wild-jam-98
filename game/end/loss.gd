extends Control


const main_menu = "res://menu/menu.tscn"

var default_phrase = "The rogue mechs have invaded and taken over your village."

var loser := "Were you even trying?"
var sucks := "The mechs were too strong today."
var mid := "The resistance remains strong, in honor of you."
var better := "The mechs respected your power."
var great := "The mechs spent so much energy on attacking you, they had to shutdown a few months later."

func update(score: int) -> void:
	%Score.text = "Your score: %s" % score
	var phrase := loser
	if score > 1000:
		phrase = great
	elif score > 750:
		phrase = better
	elif score > 500:
		phrase = mid
	elif score > 100:
		phrase = sucks
	%Descriptor.text = "%s\n%s" % [default_phrase, phrase]

func main_menu_pressed() -> void:
	get_tree().change_scene_to_file(main_menu)
	%Button.text = "Loading"
