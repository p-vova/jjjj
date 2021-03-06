local super = Object
ui.button = Object.new(super)

local flags = {}
function ui.button:new()
    local self = super.new(self)

    self.m = self.class:alloc():init()
    objc.Lua(self.m, self)

    for sel, flag in pairs(flags) do
        self.m:addTarget_action_forControlEvents(self.m, objc.SEL(sel), flag)
    end

    self:setColor(objc.UIColor:blackColor())

    return self
end

function ui.button:setTitle(text, state)
    self.m:setTitle_forState(text, state or UIControlStateNormal)
end

function ui.button:setColor(color, state)
    self.m:setTitleColor_forState(color, state or UIControlStateNormal)
end

function ui.button:ontoggle()
end

function ui.button:onpress(pressed)
    local color
    if pressed then
        color = objc.UIColor:colorWithRed_green_blue_alpha(0, 0, 0, 0.1)
    else
        color = objc.UIColor:whiteColor()
    end
    self.m:setBackgroundColor(color)
end

function ui.button:ondrag(inside)
end

ui.button.class = objc.GenerateClass('UIButton')
local class = ui.button.class

local function addmethod(flag, f)
    local sel = 'button'..flag..':'
    flag = _G[flag]
    objc.addmethod(class, sel, f, ffi.arch == 'arm64' and 'v24@0:8@16' or 'v12@0:4@8')
    flags[sel] = flag
end

addmethod('UIControlEventTouchUpInside', function(self, button)
    local this = objc.Lua(self)
    this:onpress(false)
    this:ontoggle()
end)

addmethod('UIControlEventTouchUpOutside', function(self, button)
    local this = objc.Lua(self)
    this:onpress(false)
end)

addmethod('UIControlEventTouchDown', function(self, button)
    local this = objc.Lua(self)
    this:onpress(true)
end)

addmethod('UIControlEventTouchDragInside', function(self, button)
    local this = objc.Lua(self)
    this:ondrag(true)
end)

addmethod('UIControlEventTouchDragOutside', function(self, button)
    local this = objc.Lua(self)
    this:ondrag(false)
end)

return ui.button
