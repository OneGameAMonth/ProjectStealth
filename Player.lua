require("utilities")
require("ray")

local walkingSpeed = 2
local runningSpeed = 7

local numRays = 150
local coneSize = math.pi / 2
local fov = {}

local stencilFunction = function()
  love.graphics.polygon( "fill", fov )
end

-- creates the player class
local Player = {
  position = {}, size = {}, direction = 0, velocity = {},
  imageFileName = "", image = {}, hits = {}
}

Player.__index = Player

-- returns a new player
function Player:new( x, y, sizeX, sizeY, fileName )
  local newPlayer = {}
  setmetatable( newPlayer, Player)
  newPlayer.position = { x = map:toPixelCoordinates(x), y = map:toPixelCoordinates(y) }
  newPlayer.size = { x = sizeX, y = sizeY }
  newPlayer.velocity = { x = 0, y = 0 }
  newPlayer.imageFileName = fileName
  newPlayer.hits = {}
  return newPlayer
end

function Player:isNotWallCollision( x, y )
  if not map:isWalkable( x, y ) then return false end
  if not map:isWalkable( x + self.size.x, y ) then return false end
  if not map:isWalkable( x, y + self.size.y ) then return false end
  if not map:isWalkable( x + self.size.x, y + self.size.y ) then return false end
  return true
end

function Player:getCenter()
  local newPos = { x = self.position.x + ( self.size.x / 2 ), y = self.position.y + ( self.size.y / 2 ) }
  return newPos
end

function Player:load()
  self.image = love.graphics.newImage(self.imageFileName)
end

function Player:update(dt)
  local center = self:getCenter()

  -- Handle Speed
  local movementSpeed = 0
  if love.keyboard.isDown( "lshift" ) then
    movementSpeed = runningSpeed
  else
    movementSpeed = walkingSpeed
  end

  -- Handle Position
  if love.keyboard.isDown( "w" ) and self:isNotWallCollision( self.position.x, self.position.y - movementSpeed ) then
    self.position.y = self.position.y - movementSpeed
  end
  if love.keyboard.isDown( "s" ) and self:isNotWallCollision( self.position.x, self.position.y + movementSpeed ) then
    self.position.y = self.position.y + movementSpeed
  end
  if love.keyboard.isDown( "a" ) and self:isNotWallCollision( self.position.x - movementSpeed, self.position.y ) then
    self.position.x = self.position.x - movementSpeed
  end
  if love.keyboard.isDown( "d" ) and self:isNotWallCollision( self.position.x + movementSpeed, self.position.y ) then
    self.position.x = self.position.x + movementSpeed
  end

  -- Handle Direction
  local mouse = { x = love.mouse.getX() * camera.scale - camera.x, y = love.mouse.getY() * camera.scale - camera.y }
  self.direction = getDirection( self.position, mouse )

  -- Handle Camera
  local distance = getDistance( self:getCenter(), mouse ) / 2
  if distance > 400 then distance = 400 end
  local center = transform( self:getCenter(), self.direction, distance )
  camera:setPos(  center.x - ( ( camera.scale * love.graphics.getWidth() ) / 2 ),
    center.y - ( ( camera.scale * love.graphics.getHeight() ) / 2 ) )

  -- Handle FOV
  self.hits = {}
  fov = {}
  table.insert( fov, self:getCenter().x )
  table.insert( fov, self:getCenter().y )
  local currentDir = self.direction - ( coneSize / 2 )
  for i = 1, numRays do
    local newHit = castSingleRay( self:getCenter(), currentDir )
    table.insert( self.hits, newHit )
    table.insert( fov, newHit.x )
    table.insert( fov, newHit.y )
    currentDir = currentDir + ( coneSize / numRays )
  end
end

function Player:draw()

  local center = self:getCenter()

  -- -- Draw rays -- uncomment this to draw each ray as a line
  -- love.graphics.setColor( 0, 255, 0 )
  -- for i = 1, #self.hits do
  --   local currentHit = self.hits[i]
  --   love.graphics.line( center.x, center.y, currentHit.x, currentHit.y )
  -- end

  -- Draw fog
  local myStencil = love.graphics.newStencil(stencilFunction)
  love.graphics.setInvertedStencil(myStencil)
  love.graphics.setColor( 0, 0, 0, 200 )
  love.graphics.rectangle( "fill", 0, 0, map.width * map.tileSize, map.height * map.tileSize )
  love.graphics.setStencil()

  -- Draw player
  love.graphics.draw( self.image, self.position.x, self.position.y )

  -- Draw direction
  local lineEnd = transform( center, self.direction, 30 )
  love.graphics.setColor( 255, 0, 0 )
  love.graphics.line( center.x, center.y, lineEnd.x, lineEnd.y )

end

return setmetatable(Player,{
  __call = function(self,...)
    return self:new(...)
  end
})