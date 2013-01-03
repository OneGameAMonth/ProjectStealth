require("camera")

local TileMap =  require("TileMap")
local ATL = require("AdvTiledLoader")
ATL.Loader.path = 'maps/'
map = TileMap( ATL.Loader.load("test.tmx"), 64 )

local Player = require("Player")
local player = Player( 2, 21, 32, 32, "player.png" )
local time = 0

love.graphics.setColorMode( "replace" )

function love:load()
  player:load()
end

function love:update()
  player:update(time)
  time = time + 1
end

function love:draw()
  camera:draw()
  map:autoDrawRange( camera.x, camera.y, 1 / camera.scale, pad )
  map:draw()
  player:draw()
end