local faceVals = require("faces")
local Object = require("classic")

Die = Object.extend(Object)

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
    self.displayed = self.up
end

function Die:roll()
    self.up = self.faces[love.math.random(1, #self.faces)]
    self.rolling = true
    return self.up
end

function Die:changeFace(i, face)
    if i < 1 or i > #self.faces then
        error("Invalid face index")
        return
    end
    self.faces[i] = face
end

function Die:addFace(face)
    table.insert(self.faces, face)    
end

function Die:draw()
    love.graphics.setColor(0, 0, 0, .5)
    love.graphics.rectangle("fill", (self.x - self.width / 2) + 5, (self.y - self.height / 2) + 5, self.width + 5, self.height + 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    if self.rolling and math.abs(self.lastRoll - love.timer.getTime()) < 0.5 then
        if math.abs(self.lastDraw - love.timer.getTime()) >= 0.1 then
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