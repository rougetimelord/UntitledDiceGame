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
    Item.super.new(self, x, y, 128, 128, "", Fonts.IAS24)
    self.face = face
    self.purchased = false
end

function Item:draw()
    if self.purchased then
        love.graphics.setColor(.2, .2, .2)
        love.graphics.rectangle("fill", self.x - 64, self.y - 64, 128, 128)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(Fonts.IAS24)
        love.graphics.print("Sold out", self.x, self.y, 0, 1, 1, Fonts.IAS24:getWidth("Sold out") / 2, Fonts.IAS24:getHeight() / 2)
        return
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x - 64, self.y - 64, 128, 128)
    love.graphics.draw(self.face.image, self.x, self.y, 0, 128 / self.face.image:getWidth(), 128 / self.face.image:getHeight(), self.face.image:getWidth() / 2, self.face.image:getHeight() / 2)
    love.graphics.setFont(Fonts.IAS24)
    local str = self.face.description .. ": $" .. self.face.cost
    love.graphics.print(self.face.description .. ": $" .. self.face.cost, self.x, self.y + 64 + Fonts.IAS24:getHeight() / 2, 0, 1, 1, Fonts.IAS24:getWidth(str) / 2, Fonts.IAS24:getHeight() / 2)
end

function Item:check(x, y)
    if self.purchased then
        return
    end
    if Item.super.clicked(self, x, y) then
        if self.face.cost <= Score.money then
            Score.money = Score.money - self.face.cost
            self.purchased = true
            for _, value in ipairs(Dice) do
                value:addFace(self.face)
            end
        else
            FailSound:play()
        end
    end
end

function Shop:new()
    self.faces = {Item(love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2, getRandomFace()), Item(love.graphics.getWidth() / 2 + 200, love.graphics.getHeight() / 2, getRandomFace())}
    self.buyPlays = Button(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() - 200, 200, 64, "Buy More Plays: $10", Fonts.IAS24, function()
        if Score.money >= 10 then
            Score.money = Score.money - 10
            Player.tries = Player.tries + 1
            Score.tries = Player.tries
            self.buyPlays.callback = function()
                FailSound:play()
            end
            self.buyPlays.text = "Sold Out"
        else
            FailSound:play()
        end
    end)
    self.exit = Button(love.graphics.getWidth() / 2 - 64, love.graphics.getHeight() - 100, 128, 64, "Exit", Fonts.IAS24, function()
        InShop = false
        RoundIntro = true
    end)
end

function Shop:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(Fonts.IAS36)
    love.graphics.print("Shop", love.graphics.getWidth() / 2, 150, 0, 2, 2, Fonts.IAS36:getWidth("Shop") / 2, Fonts.IAS36:getHeight() / 2)
    love.graphics.setFont(Fonts.IAS24)
    love.graphics.print("Money: $" .. Score.money, love.graphics.getWidth() / 2, 250, 0, 1, 1, Fonts.IAS24:getWidth("Money: $") / 2, Fonts.IAS24:getHeight() / 2)
    for _, face in ipairs(self.faces) do
        face:draw()
    end
    self.buyPlays:draw()
    self.exit:draw()
end

function Shop:check(x, y)
    for _, value in ipairs(self.faces) do
        value:check(x, y)
    end
    self.buyPlays:check(x, y)
    self.exit:check(x, y)
end

return Shop