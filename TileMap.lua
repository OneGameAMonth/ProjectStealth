-- Creates a tilemap class
local TileMap = {
  tileSize = 0, width = 0, height = 0,
  map = {}, collisionMap = {}
}

TileMap.__index = TileMap

-- Returns a new tilemap
function TileMap:new(map, tileSize)
  local newMap = {}
  setmetatable( newMap, TileMap )
  newMap.map = map
  newMap.tileSize = tileSize
  newMap.width = map.width
  newMap.height = map.height
  newMap.collisionMap = {}

  -- generate empty collision map
  for i=0, newMap.width do
    newMap.collisionMap[i] = {}
    for j=0, newMap.height do
      newMap.collisionMap[i][j] = 0
    end
  end


  -- get any collision values from map
  for x, y, tile in newMap.map("unwalkable"):iterate() do
    newMap.collisionMap[x][y] = 1
  end
  return newMap
end

function TileMap:inBounds( x, y )
  return self:toTileCoordinates( x ) >= 0 and self:toTileCoordinates( y ) >= 0 and
  self:toTileCoordinates( x ) < self.width and self:toTileCoordinates( y ) < self.height
end

-- Public Helpers
function TileMap:pixelWidth() return self.width * self.tileSize end
function TileMap:pixelHeight() return self.height * self.tileSize end
function TileMap:toPixelCoordinates( tile ) return tile * self.tileSize end
function TileMap:toTileCoordinates( pixel ) return math.floor( pixel / self.tileSize ) end

-- Public Methods
function TileMap:draw()
  self.map:draw()
end

function TileMap:autoDrawRange( x, y, s, pad )
  self.map:autoDrawRange( x, y, s, pad )
end

function TileMap:isWalkable( x, y )
  return self.collisionMap[ self:toTileCoordinates( x ) ][ self:toTileCoordinates( y ) ] == 0
end

return setmetatable(TileMap,{
  __call = function(self,...)
    return self:new(...)
  end
})