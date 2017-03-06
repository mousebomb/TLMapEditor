TL map editor 
with game terrain engine


# map

- Terrain Heightmap
- Terrain Texture & alphalayer ( splatalpha )
- Collider
- Entity put
- Entity Static Shadow (Lightmap)
- UI

Terrain Heightmap
 - Brush hover position correction
 - Brush height restriction & settings

Splatalpha
    - Textures import 
    - Textures draw & record UVs

Entity put
    - Entities import 



## Map fileformat Specification
zlib压缩

uint 版本号
UTFString 地图名
Short 地图横向长度
Short 地图纵向长度
[Short * ( 地图横向长度+1 ) * (地图纵向长度+1 ) ] 高度图
uint 纹理字节长度
[Byte * 纹理字节长度 ]
[UTFString * 5] 纹理名称5幅（备注：以后会改动）

Short 刚体数
[ (float ,     short,short,short,short,   short)     *刚体数]

Short 模型层数
     [模型层数*
          (
          UTFString 模型层名
          Short 该层模型数量
               [(UTFString 精灵表内的Id，int x坐标 int y坐标 int z坐标 ,short 角度) * 该层模型数量]  注意，服务器的坐标 用的是x,z 而且z需要取反
          )
     ]

[地图纵向长度 *
     地图横向长度 * ( Byte 区域类型 )
]

float,float,float  光照角度

Short 功能点数量
[功能点数量 * (Short,Short,Byte) ] 功能点格子坐标和类型


UTFString 天空盒纹理

