local translatespeed = 25

camera = {}
camera.x = 0
camera.y = 0
camera.scale = 1.3

function camera:setPos( x, y )
  camera.x = -x
  camera.y = -y
end

function camera:draw()
  love.graphics.scale( 1 / self.scale, 1 / self.scale )
  love.graphics.translate( self.x, self.y )
end