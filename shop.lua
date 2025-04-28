Faces = require "faces"
Fonts = require "fonts"
Object = require "classic"
Button = require "button"

Shop = Object:extend()
Item = Button:extend()

local keyset = {}
for key in pairs(Faces) do
    table.insert(keyset, key)
end

local function getRandomFace()
    return Faces[keyset[math.random(1, #keyset)]]
end

function Item:new(x, y, face)
    Item.new(self, x, y, 128, 128, face.name, Fonts.IAS24)
    self.face = face
end

function Item:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, 128, 128)
    love.graphics.draw(self.face.image, self.x, self.y, 0, 128 / self.face.image:getWidth(), 128 / self.face.image:getHeight())
end

function Shop:new()
    self.faces = {Item(love.graphics.getWidth() / 3 - 64, love.graphics.getHeight() / 2 - 64, getRandomFace())}
end

function Shop:draw()
    
end