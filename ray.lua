require("utilities")

function backtrace( source, angle, type )
  while true do
    source = transform( source, angle, -1 )
    if type == "border" then
      if map:inBounds( source.x, source.y ) then
        return source
      end
    elseif type == "wall" then
      if not map:isWalkable( source.x, source.y ) then
        return source
      end
    end
  end
end

function castSingleRay( source, angle )
  while true do
    source = transform( source, angle, 16 )
    if not map:isWalkable( source.x, source.y ) then
      while true do
        source = transform( source, angle, 8 )
        if not map:inBounds( source.x, source.y ) then
          return backtrace( source, angle, "border" )
        elseif map:isWalkable( source.x, source.y ) then
          return backtrace( source, angle, "wall" )
        end
      end
    end
  end
end