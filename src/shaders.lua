shaders = {}

-- NOTE: These shaders are written using GLSL for Love2D

-- Hole-punch light source
shaders.simpleLight = love.graphics.newShader[[
    extern number playerX = 0;
    extern number playerY = 0;
    number radius = 200;
    extern number opacity = 0;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2) + pow(screen_coords.y - playerY, 2), 0.5);
        if (distance < radius) {
            return vec4(0, 0, 0, 0);
        }
        else {
            return vec4(0, 0, 0, 0.1 * opacity);
        } 
    }
]]

-- Faded light source
shaders.trueLight = love.graphics.newShader[[
    extern number playerX = 0;
    extern number playerY = 0;
    extern number opacity = 0;
    number radius = 350;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2) + pow(screen_coords.y - playerY, 2), 0.5);
        number alpha = distance / radius;
        return vec4(0, 0, 0, min(alpha * opacity * 0.1, 0.6));
    }
]]

-- White damage flash
shaders.whiteout = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        vec4 pixel = Texel(texture, texture_coords);
        if (pixel.a == 1) {
            return vec4(1, 1, 1, 1);
        } else {
            return vec4(0, 0, 0, 0);
        }
    }
]]

function shaders:update(dt, opacityTrecker)

    -- distance between center (of the camera) and players x + half of the screen_width
    local lightX = (player.x - cam.x) + (WINDOW_WIDTH/2)
    local lightY = (player.y - cam.y) + (WINDOW_HEIGHT/2)

    shaders.simpleLight:send("playerX", lightX)
    shaders.simpleLight:send("playerY", lightY)
    shaders.simpleLight:send("opacity", opacityTrecker)
    shaders.trueLight:send("playerX", lightX)
    shaders.trueLight:send("playerY", lightY)
    shaders.trueLight:send("opacity", opacityTrecker)
end