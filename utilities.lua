function getDistance( point1, point2 )
  dx = point2.x - point1.x
  dy = point2.y - point1.y
  return 1 * ( math.sqrt(dx * dx + dy * dy) )
end

function getDirection( point1, point2 )
  dx = point2.x - point1.x
  dy = point2.y - point1.y
  return math.rad( math.atan2(dy, dx) * 180 / math.pi )
end

function transform( point, dir, dist )
  local newPoint = {}
  newPoint.x = point.x + dist * math.cos( dir )
  newPoint.y = point.y + dist * math.sin( dir )
  return newPoint
end