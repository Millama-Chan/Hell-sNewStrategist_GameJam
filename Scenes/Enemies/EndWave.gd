extends PathFollow2D

signal base_damage(damage)
#signal destroyed

var speed = 0.5
var hp = 1500
var base_damage = 70

onready var health_bar = get_node("HealthBar")
onready var impact_area = get_node("Impact")
var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)

func _physics_process(delta):
	if unit_offset == 1.0 :
		emit_signal("base_damage", base_damage)
		queue_free()
	move(delta)

func move(delta):
	set_offset(get_offset() + speed + delta)
	health_bar.set_position(position - Vector2(30,30))

func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <=0:
		on_destroy()

func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instance()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy():
	get_node("KinematicBody2D").queue_free()
	#yield(get_tree().create_timer(0.2),"timeout")
	$Timer.start(0.2); yield($Timer, "timeout")
	self.queue_free()
	
	randomize()
	var points_range = [1,2,3,4,5] ##Low points on purpose
	var random_point = points_range[randi() % points_range.size()]
	GameData.cash += random_point

