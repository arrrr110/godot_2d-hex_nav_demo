extends TileMap

const main_layer := 0
const main_atlas_id = 0

# hard coded TileMap size 设置网格规格
var map_size = Vector2(6, 6)
# valid cells list 所有合法网格集合
var valid_cells := []
# graph as a simple dictionary 网格片将建立一个字典
var pos_clicked
#var map_graph = {}
# graph as an instance of Godot's AStar2D class 网格片是一个实例
# 寻路变量
var astar_grid

func _init():
	#var arr = get_used_rect()
	#print("Hello, world!", arr)
	pass


func _ready():
	valid_cells = get_used_cells(0)
	print("合法网格:", valid_cells)
	#valid_cells.reverse()
	#print('逆序排列:', valid_cells)
	#print("test:", new_find_path(Vector2(1,0), Vector2(7,5)))

	# arr测试
	
func _input(event):
	#print(event)
	if event is InputEventMouseMotion:
	# update labels
		get_node("../WorldPositionLabel").text = str(event.position)
		get_node("../TilePositionLabel").text = str(local_to_map(to_local(event.position)))

# 坐标测试函数
func position_check(global_clicked : Vector2):
	pos_clicked = local_to_map(to_local(global_clicked))
	#print("--------------------")
	#print("全局坐标:", global_clicked)
	#print("节点下本地坐标:", to_local(global_clicked))
	#print("网格:", pos_clicked)
	#print("网格中心坐标:", map_to_local(pos_clicked))
	#print("网格中心全局坐标:", to_global(map_to_local(pos_clicked)))
	return {
		'local_position' : to_local(global_clicked),
		'pos_clicked' : pos_clicked,
		'local_pos_center_position' : map_to_local(pos_clicked),
		'global_pos_center_position' : to_global(map_to_local(pos_clicked)),
	}
	
# Djikstra
# 自动寻路，没考虑多个棋子的站位问题
func find_path(from : Vector2, to : Vector2) -> Array:
	#var start = str(from)
	#var end = str(to)
	# 自动寻路
	astar_grid = AStarGrid2D.new() # 创建实例
	astar_grid.region = get_used_rect() # 返回该地图的包围矩形，包围所有图层中的已使用（非空）的图块。
	astar_grid.cell_size = Vector2(16, 16) 
	# 要用于计算由 get_point_path() 返回的结果点位置的点单元的大小。如果更改了这个值，在查找下一个路径之前需要调用 update()。
	astar_grid.update()
	var path = astar_grid.get_id_path(from, to)
	print("寻路astar_grid_path:",path, astar_grid.region)
	return path

func path_dict(cells : Array) -> Dictionary:
	var dict = {}
	for id in cells.size():
		dict[id] = cells[id]
	return dict
	
# 精确的通过循环建立集合很难写，改为穷举法
func create_path_map(cells : Array) -> Object:
	var astar = AStar2D.new()
	var dict = path_dict(cells)
	var idx = 0
	
	for i in dict:
		astar.add_point(i, dict[i])

	for n in dict:
		var surround_spot_list : Array = get_surrounding_cells(dict[n])
		#print('surround:', surround_spot_list)
		for it in surround_spot_list:
			var m = dict.find_key(it)
			#print('m:', m)
			if m:
				astar.connect_points(n, m)
		idx += 1
	return astar
	

func new_find_path(from : Vector2, to : Vector2) -> Array:
	#astar_grid = create_path_map(valid_cells)
	var cells = valid_cells
	var astar : Object = create_path_map(cells)
	var dict = path_dict(cells)

	
	var x = dict.find_key(Vector2i(from))
	var y = dict.find_key(Vector2i(to))
	
	var path_list = astar.get_id_path(x, y)
	var path = []
	for i in path_list:
		path.append(astar.get_point_position(i))
	#print("寻路astar_grid_path:",path)

	return path
