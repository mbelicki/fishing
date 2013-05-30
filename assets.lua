-- assets.lua

require 'class'

-- Assets implementation:

Assets = class()

function Assets:init()
    self.screen = {}
    self.screen.width  = 800
    self.screen.height = 600

    self.dialogFont = love.graphics.newImageFont("assets/inconsolata22.png",
                                        " abcdefghijklmnopqrstuvwxyz" ..
                                        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .. 
                                        "123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(self.dialogFont)

    self.sceneBackground = nil
    self.sceneNightSky   = nil
    self.sceneDaySky     = nil

    self.imageBuffer = {}
end

function Assets:loadSceneGraphics(scene)
    local img = love.graphics.newImage

    self.sceneBackground = img(scene.dayImage);
    self.sceneNightSky   = img(scene.nightSkyImage);
    self.sceneDaySky     = img(scene.daySkyImage);
end

function Assets:clearImageBuffer()
    -- this is said to unload images, but I haven't checked if it works
    self.imageBuffer = nil
    collectgarbage('collect')
    self.imageBuffer = {}
end

function Assets:getImage(path)
    local image = self.imageBuffer[path]
    if image == nil then
        log('info', "loading : " .. path .. "\n")
        image = love.graphics.newImage(path)
        image:setFilter('nearest', 'nearest')
        self.imageBuffer[path] = image
    end
    return image
end
