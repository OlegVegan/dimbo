extends Node2D

@onready var box_sound = $box_sound
@onready var coin_sound = $coin_sound
@onready var exp_sound = $expl
var can_play_box_sound = true
var can_play_coin_sound = true

func _ready():
	Globals.crate_takes_dmg.connect(_on_crate_takes_dmg)
	Globals.coin_picked.connect(_on_coin_picked)
	Globals.nade_exp.connect(_on_nade_exp)
	
	
func _on_crate_takes_dmg():	
	if can_play_box_sound:
		can_play_box_sound = false
		box_sound.pitch_scale = randf_range(0.8, 1.2)
		box_sound.play()	

func _on_coin_picked():
	if can_play_coin_sound:
		can_play_box_sound = false
		coin_sound.pitch_scale = randf_range(0.9, 1.1)
		coin_sound.play()	

func _on_box_sound_finished():
	can_play_box_sound = true


func _on_coin_sound_finished():
	can_play_coin_sound = true
	
func _on_nade_exp():
	exp_sound.pitch_scale = randf_range(0.9, 1.1)
	exp_sound.play()
	
	
