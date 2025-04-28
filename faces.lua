local faces = {
    one = {name="1", image = love.graphics.newImage("assets/img/1.png"), scoring = function (score) return score + 1 end},
    two = {name="2", image = love.graphics.newImage("assets/img/2.png"), scoring = function (score) return score + 2 end},
    three = {name="3", image = love.graphics.newImage("assets/img/3.png"), scoring = function (score) return score + 3 end},
    four = {name="4", image = love.graphics.newImage("assets/img/4.png"), scoring = function (score) return score + 4 end},
    five = {name="5", image = love.graphics.newImage("assets/img/5.png"), scoring = function (score) return score + 5 end},
    six = {name="6", image = love.graphics.newImage("assets/img/6.png"), scoring = function (score) return score + 6 end},
}

return faces