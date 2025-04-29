local faces = {
    one = {name = "one", image = love.graphics.newImage("assets/img/1.png"), scoring = function (score) return {score=score + 1} end, description = "One", cost = 1},
    two = {name = "two", image = love.graphics.newImage("assets/img/2.png"), scoring = function (score) return {score=score + 2} end, description = "Two", cost = 1},
    three = {name = "three", image = love.graphics.newImage("assets/img/3.png"), scoring = function (score) return {score=score + 3} end, description = "Three", cost = 1},
    four = {name = "four", image = love.graphics.newImage("assets/img/4.png"), scoring = function (score) return {score=score + 4} end, description = "Four", cost = 2},
    five = {name = "five", image = love.graphics.newImage("assets/img/5.png"), scoring = function (score) return {score=score + 5} end, description = "Five", cost = 3},
    six = {name = "six", image = love.graphics.newImage("assets/img/6.png"), scoring = function (score) return {score=score + 6} end, description = "Six", cost = 4},
    clown = {name = "clown", image = love.graphics.newImage("assets/img/clown.png"), scoring = function (score) return {score=score} end, description = "Becomes the most common face", cost = 5},
    eye = {name = "eye", image = love.graphics.newImage("assets/img/eye-L.png"), scoring = function (score, mult) return {score=score, mult = mult + 2} end, description = "+0 score... +2 mult", cost = 8},
}

return faces