local faces = {
    one = {name = "one", image = love.graphics.newImage("assets/img/1.png"), scoring = function (score) return score + 1 end, description = "One", cost = 1},
    two = {name = "two", image = love.graphics.newImage("assets/img/2.png"), scoring = function (score) return score + 2 end, description = "Two", cost = 1},
    three = {name = "three", image = love.graphics.newImage("assets/img/3.png"), scoring = function (score) return score + 3 end, description = "Three", cost = 1},
    four = {name = "four", image = love.graphics.newImage("assets/img/4.png"), scoring = function (score) return score + 4 end, description = "Four", cost = 1},
    five = {name = "five", image = love.graphics.newImage("assets/img/5.png"), scoring = function (score) return score + 5 end, description = "Five", cost = 1},
    six = {name = "six", image = love.graphics.newImage("assets/img/6.png"), scoring = function (score) return score + 6 end, description = "Six", cost = 1},
    clown = {name = "clown", image = love.graphics.newImage("assets/img/clown.png"), scoring = function (score) return score end, description = "Becomes the most common face", cost = 3},
}

return faces