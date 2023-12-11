extends Node2D

@onready var m1 = preload("res://maps/map1.tscn")
@onready var m2 = preload("res://maps/map2.tscn")
@onready var m3 = preload("res://maps/map3.tscn")
@onready var m4 = preload("res://maps/map4.tscn")
@onready var m5 = preload("res://maps/map5.tscn")
@onready var m6 = preload("res://maps/map6.tscn")
@onready var m7 = preload("res://maps/map7.tscn")
@onready var m8 = preload("res://maps/map8.tscn")
@onready var m9 = preload("res://maps/map9.tscn")
@onready var m10 = preload("res://maps/map10.tscn")

var selectedMap
var mapName
var inst = false

func _ready():
	$Timer.wait_time = randf_range(0.0, 0.1)
	if inst:
		$Timer.wait_time = 0
	$Timer.start()

func _on_timer_timeout():	
	if selectedMap == 1:
		var m = m1.instantiate()
		add_child(m)
	elif selectedMap == 2:
		var m = m2.instantiate()
		add_child(m)
	elif selectedMap == 3:
		var m = m3.instantiate()
		add_child(m)
	elif selectedMap == 4:
		var m = m4.instantiate()
		add_child(m)
	elif selectedMap == 5:
		var m = m5.instantiate()
		add_child(m)
	elif selectedMap == 6:
		var m = m6.instantiate()
		add_child(m)
	elif selectedMap == 7:
		var m = m7.instantiate()
		add_child(m)
	elif selectedMap == 8:
		var m = m8.instantiate()
		add_child(m)
	elif selectedMap == 9:
		var m = m9.instantiate()
		add_child(m)
	elif selectedMap == 10:
		var m = m10.instantiate()
		add_child(m)
