# 2D Hexagonal Map Navigation Demo(4.x)

This is an example of implementing hexagonal TileMap navigation in Godot.

In the 4.x version, the cells of the TileMap can be set to hexagons. Hexagons can dock with six other tiles, so they differ from rectangular grids in terms of grid coordinates and pathfinding.

This project provides a solution.

First, we generate an AStar2D instance and add a new point at the given location of all given identifiers;
Then we obtain each grid and its adjacent points in turn, and connect each grid with its adjacent points;
Finally, we return a list of all cells adjacent to the cell at coordinates, which is the navigation path.

This project is based on the 3.x version of the same name!(https://godotengine.org/asset-library/asset/1888). At that time, the TileMap format only supported rectangles, so the author created many methods to handle hexagonal calculations. The internal principles of this version are different from those of the 3.x version.

![Screenshot](screenshots/demo.gif)


# 2D 六边形地图导航演示(4.x)

在4.x版本，TileMap的单元格可以设为六边形。六边形可以对接另外六个瓦片，因此在网格坐标以及寻路上都与矩形网格不同。

这个项目提供了一个解决方案。

首先我们生成一个AStar2D实例，并在所有给定标识符的给定位置添加一个新点；
然后我们依次获取每个网格及其相邻点，并将每个网格与相邻点连接起来；
最后我们返回与 coords 处的单元格相邻的所有单元格的列表，这个列表就是导航路径。

这个项目参考了同名下的3.x版本，当时的版本TileMap格式仅有矩形，因此作者建立了很多方法来处理六边形的计算。本版本内部的原理与3.x版本并不相同。
