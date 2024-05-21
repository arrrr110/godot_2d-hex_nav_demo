extends Node2D # 挂在根节点上

# 全局 Transform2D * root坐标
@onready var global_pos: Vector2 = global_transform * position
@onready var global_rot: float = global_transform.x.angle() 
# 角度比较特殊，但我们可以通过获取全局变换的基向量i的旋转来获取其全局旋转
@onready var global_scl: Vector2 = global_transform * scale

var tile_map_pos

func _ready():
	print("root坐标", position)
	#print("root网格坐标:", global_pos,", root旋转：",rad_to_deg(global_rot),", root缩放：",global_scl)

func _unhandled_input(event):
	if event is InputEventMouse and event.is_action_pressed("left_click"):
		#print('get_global_transform():', get_global_transform())
		#print('Camera2D:', $Camera2D.get_canvas_transform().affine_inverse())
		#print('$Player:', $Player.get_canvas_transform().affine_inverse())
		var event_transform = Transform2D().translated(event.position)
		#print('系统transform:', event_transform)
		
		# 原有系统transform * 变换方向矩阵 = 目标系统transform
		var grid_local_transform = event_transform * $Camera2D.get_canvas_transform().affine_inverse()
		#print('tilemap_transform:', grid_local_transform)
		
		# get_origin() 返回该变换的原点（平移）。获得目标系统的网格坐标
		#print('$TileMap系统的网格坐标:', $TileMap.local_to_map(grid_local_transform.get_origin()))
		tile_map_pos = $TileMap.local_to_map(grid_local_transform.get_origin())

