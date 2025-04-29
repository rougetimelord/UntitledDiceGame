local faceVals = require("faces")
local Object = require("classic")

Die = Object:extend()

function Die:new(faces, x, y, width, height)
    self.faces = faces or {faceVals.one, faceVals.two, faceVals.three, faceVals.four, faceVals.five, faceVals.six}
    self.up = self.faces[love.math.random(#self.faces)]
    self.x = x or love.graphics.getWidth() / 2
    self.y = y or love.graphics.getHeight() / 2
    self.width = width or 128
    self.height = height or 128
    self.lastRoll = 0
    self.lastDraw = 0
    self.rolling = false
    self.shake = 0
    self.displayed = self.up
    self.oldX = self.x
    self.oldY = self.y
end

function Die:roll()
    if(Score.rolls <= 0) then
        self.oldX = self.x
        self.oldY = self.y
        self.shake = 0.5
        FailSound:play()
        return
    end
    RollSound:setPitch(love.math.random(80, 120) / 100)
    RollSound:play()
    self.up = self.faces[love.math.random(1, #self.faces)]
    self.rolling = true
    return self.up
end

function Die:addFace(face)
    table.insert(self.faces, face)
end

function Die:update(dt)
    if self.shake > 0 then
        self.shake = self.shake - dt
        local x = love.math.random(-self.shake, self.shake)
        local y = love.math.random(-self.shake, self.shake)
        self:move(self.x + x, self.y + y)
    else
        self:move(self.oldX, self.oldY)
    end
end

function Die:draw()
    love.graphics.setColor(0, 0, 0, .5)
    love.graphics.rectangle("fill", (self.x - self.width / 2) + 5, (self.y - self.height / 2) + 5, self.width + 5, self.height + 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    if self.rolling and math.abs(self.lastRoll - love.timer.getTime()) < 0.5 then
        if math.abs(self.lastDraw - love.timer.getTime()) >= 0.05 then
            self.displayed = self.faces[love.math.random(#self.faces)]
            self.lastDraw = love.timer.getTime()
        end
    else
        self.rolling = false
        self.displayed = self.up
    end
    love.graphics.draw(self.displayed.image, self.x - self.width / 2, self.y - self.height / 2, 0, self.width / 256, self.height / 256)
end

function Die:clicked(x, y)
    if math.abs(self.lastRoll - love.timer.getTime()) >= 0.5 and x >= self.x - self.width / 2 and x <= self.x + self.width / 2 and y >= self.y - self.height / 2 and y <= self.y + self.height / 2 then
        self.lastRoll = love.timer.getTime()
        return true
    end
    return false
end

function Die:move(x, y)
    self.x = x
    self.y = y
end

return Die