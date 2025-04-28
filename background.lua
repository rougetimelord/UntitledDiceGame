local background = Object:extend()
function background:new(filename)
    self.image = love.graphics.newImage(filename)
    self.image:setWrap("repeat", "repeat")
    self.x = 0
    self.y = 0
    return self
end

function background:update(dt)
    self.x = (self.x + dt * 20) % self.image:getWidth()
    self.y = (self.y + dt * 20) % self.image:getHeight()
end

function background:draw()
    love.graphics.setColor(.5, .5, .5, .25)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    local quad = love.graphics.newQuad(self.x, self.y, love.graphics.getWidth() + self.image:getWidth(), love.graphics.getHeight() + self.image:getHeight(), self.image)
    love.graphics.draw(self.image, quad, 0, 0)
end

return background