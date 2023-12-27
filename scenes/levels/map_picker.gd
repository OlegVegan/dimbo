extends Node2D

@onready var maps = [preload("res://maps/map1.tscn"),
preload("res://maps/map2.tscn"),
preload("res://maps/map3.tscn"),
preload("res://maps/map4.tscn"),
preload("res://maps/map5.tscn"),
preload("res://maps/map6.tscn"),
preload("res://maps/map7.tscn"),
preload("res://maps/map8.tscn"),
preload("res://maps/map9.tscn"),
preload("res://maps/map10.tscn")]

var selectedMap
var mapName
var inst = false

func _ready():
	$Timer.wait_time = randf_range(0.0, 0.2)
	if inst: $Timer.wait_time = 0
	$Timer.start()

func _on_timer_timeout():
	var m = maps[selectedMap - 1].instantiate()
	add_child(m)
