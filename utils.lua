-- utils.lua

-- Copyright (C) 2013 Mateusz Belicki
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.


-- A bunch of utitlity functions;

-- Checks if point is inside given rectangle.
--
-- @argument point: Table with "x" and "y" numeric members, represents a point
--                 in 2D space.
--
-- @argument rectangle: Table with "x", "y", "width" and "height" numeric
--                     members, represents axis aligned rectangle in 2D space.
--
-- @return: boolean value
function isPointInRect(point, rect)
    if point.x > rect.x and point.x < rect.x + rect.width and
       point.y > rect.y and point.y < rect.y + rect.height 
    then
      return true;
    else 
      return false;
    end
end

-- Returns current hour as a single number, where integer part is hour value
-- and fractional part contains normalized minutes and seconds, e.g. 
-- 5:30:00 p.m. will be encoded as 17.5
--
-- @return: floating number
function getCurrentTime()
    local date = os.date("*t");
    local normalSec = date.sec / 60;
    local normalMin = (date.min + normalSec )/ 60;
    return date.hour + normalMin;
end

-- Find value between a i b using linear interpolation with given t factor
--
-- @argument a b: Input value, numeric.
-- 
-- @argument t: Interpolation factor, numeric.
--
-- @return: Computed numeric value.
function lerp(a, b, t)
    return a + (b - a) * t
end

-- Log message of given kind to stderr
--
-- @argument kind: message type
--
-- @argument message: message content
--
-- @return: void
function log(kind, message)
    local string = ' [ ' .. kind .. ' ] -- ' .. message .. '\n'
    io.stderr:write(string)
end
