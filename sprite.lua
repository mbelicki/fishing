-- sprite.lua

require 'class'

-- Sprite implementation:

Sprite = class()

function Sprite:init(imageInfo, gridOffset, gridSize, frameCount)
     -- init quads
     local w = gridSize.width
     local h = gridSize.height
     local aW = imageInfo.width
     local aH = imageInfo.height
     self.imageInfo = imageInfo
     self.quads = {}

     for i = 0, frameCount - 1 do
         local x = gridOffset.x + gridSize.width * i
         local y = gridOffset.y
         local quad = love.graphics.newQuad(x, y, w, h, aW, aH)
         self.quads[i] = quad
     end
     -- init timer
     self.frameTimer  = 0
     self.framePeriod = 0.25

     self.currentFrame = 0
     self.framesCount  = frameCount

     self.isStatic = self.framesCount == 1
end

function Sprite:getFrameTime()
    return self.framePeriod
end

function Sprite:update(dt)
    if self.isStatic then return end

    self.frameTimer = self.frameTimer + dt
    if self.frameTimer >= self.framePeriod then 
        self.frameTimer = 0
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame >= self.framesCount then
            self.currentFrame = 0
        end
    end
end

function Sprite:draw(x, y, assets)
    local quad = self.quads[self.currentFrame]
    local texture = assets:getImage(self.imageInfo.name)
    love.graphics.drawq(texture, quad, x, y)
end
