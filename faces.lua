local faces = {
    one = {name="1", image = love.graphics.newImage("assets/img/1.png"), scoring = function (score) return score + 1 end, description = "One"},
    two = {name="2", image = love.graphics.newImage("assets/img/2.png"), scoring = function (score) return score + 2 end, description = "Two"},
    three = {name="3", image = love.graphics.newImage("assets/img/3.png"), scoring = function (score) return score + 3 end, description = "Three"},
    four = {name="4", image = love.graphics.newImage("assets/img/4.png"), scoring = function (score) return score + 4 end, description = "Four"},
    five = {name="5", image = love.graphics.newImage("assets/img/5.png"), scoring = function (score) return score + 5 end, description = "Five"},
    six = {name="6", image = love.graphics.newImage("assets/img/6.png"), scoring = function (score) return score + 6 end, description = "Six"},
}

return faces