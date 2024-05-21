extends CharacterBody2D

const MOTION_SPEED = 80
const FRICTION_FACTOR = 0.89
const TAN30DEG = tan(deg_to_rad(30))




# Called when the node enters the scene tree for the first time.
#var target = position
#var velocity = Vector2()
@onready var target = position
@onready var tile_map = $"../TileMap"
@onready var line_2d = $"../Line2D"

#var target = position
#var target_pos_clicked
var tile_position := Vector2i()  # hard-coded starting tile position
var tile_path = []  # of tile positions
var world_path = []  # of global coordinates
var screen_size # Size of the game window.
@export var speed = 400



func _ready():
	screen_size = get_viewport_rect().size
	var begining_pos_dict = tile_map.position_check(position)
	tile_position = begining_pos_dict.get('pos_clicked')
	#print('target:', target)
	#print('tile_map in Player:', tile_map.valid_cells)

# 修改坐标后建立寻路列表
func _input(event):
	if event.is_action_pressed("left_click"):
		var pos_dict = tile_map.position_check(get_global_mouse_position())
		# 新任务清空
		tile_path.clear()
		world_path.clear()
		
		# 目的地网格坐标和网格中心点坐标
		var pos_clicked = pos_dict.get('pos_clicked')
		var local_pos_center_position = pos_dict.get('local_pos_center_position')
		# 寻路

		if pos_clicked in tile_map.valid_cells and not tile_position == pos_clicked:
			var path_found = []
			path_found = tile_map.new_find_path(tile_position, pos_clicked)
			#print('获得路径', path_found)
			line_2d.default_color = Color.WEB_MAROON
			
			# keep both world and map position arrays in memory
			tile_path = path_found
			# 根据路径网格，找回全局坐标
			for node in path_found:
				var path_position = tile_map.map_to_local(node)
				#print("路径：", path_position)
				world_path.append(path_position)
			# draw line
			line_2d.points = PackedVector2Array(world_path)
			# remove first (current) position 移除当前坐标点
			tile_path.remove_at(0)
			world_path.remove_at(0)
			# get next position to move to 提出下一个位置的坐标点
			tile_position = tile_path.pop_front()
			target = world_path.pop_front()
		else:
			printerr("need move OR out of area!")

func _physics_process(delta):
	if target:
		velocity = position.direction_to(target) * speed
		# look_at(target)
		if position.distance_to(target) > 5:
			move_and_slide()
		else:
			# we've reached current destination, get the next one (if any left)
			if tile_path.size() > 0:
				tile_position = tile_path.pop_front()
				target = world_path.pop_front()
