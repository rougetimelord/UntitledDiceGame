local Object = require "classic"

Button = Object:extend(Object)

function Button:new(x, y, width, height, text, font, callback)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 100
    self.height = height or 50
    self.text = text or "Button"
    self.font = font or love.graphics.getFont()
    self.callback = callback or function() end
    self.bgColor = {1, 1, 1, 1}
    self.bgInactiveColor = {1, 1, 1, 1}
    self.bgColorActive = {0.8, 0.8, 0.8, 1}
    self.textColor = {0, 0, 0, 1}
end

function Button:draw()
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(self.textColor)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, self.x, self.y + (self.height - self.font:getHeight()) / 2, self.width, "center")
end

function Button:clicked(mx, my)
    return mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

function Button:update(dt)
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        if self:clicked(mx, my) then
            self.bgColor = self.bgColorActive
            self.callback()
        end
    else
        self.bgColor = self.bgInactiveColor
    end
end

return Button