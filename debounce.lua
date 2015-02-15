-------------------------------------------------------------------------------
-- Debounce Filter
--
-- This file contains a lua class for a Debounce Filter.
--
-- The class is instantiated (@{new}) with a threshold value and a debounce
-- counter for going under and over the threshold.
-- 
-- @classmod debounce
-- @author Troy Manary
--
-------------------------------------------------------------------------------
local debounce = {}
debounce.__index = debounce

debounce.UNDER = false
debounce.OVER = true

-------------------------------------------------------------------------------
-- Constructor
-- @function new
-- @param threshold value to monitor value crossing over or under
-- @param debUnder number of consecutive values under the threshold before
--        declaring the state of the filter UNDER.
-- @param debOver number of consecutive values over the threshold before
--        declaring the state of the filter OVER.
-- @return pointer to self
-- @usage local temperature = debounce.new(10,2,5)
-------------------------------------------------------------------------------
function debounce.new(threshold, debUnder, debOver)
  local self = setmetatable({}, debounce)
  self.threshold = threshold
  self.debUnder = debUnder
  self.debOver = debOver
  self.state = debounce.UNDER
  self.counter = 0
 return self
end

-------------------------------------------------------------------------------
-- Reset filter to a known state.
-- Does not alter the filter configuration.
-- If a value is specified, it is compared to the threshold and sets the state
-- appropriately (with no consideration for existing debounce counter)
-- @function reset
-- @param value force the filter to this value. if not specified, set to 0
-- @usage temperature:reset(4) -- reset to value of 4
-- @usage temperature:reset()  -- reset to value of 0 
-------------------------------------------------------------------------------
function debounce.reset(self, value)
  self.counter = 0
  if (value < self.threshold) then
    self.state = self.UNDER
  else
    self.state = self.OVER
  end
end

-------------------------------------------------------------------------------
-- Updates the filter with a new value and determines current state as 
-- UNDER or OVER the threshold using the debounce settings.
--
-- The counter is used to track consecutive events of the same state.
-- If the current state is UNDER, then the counter tracks the number of
-- consecutive events that are over the threshold.  If the current state
-- is OVER, then the counter tracks the number of consecutive events that
-- are under the threshold.
-- When the counter exceeds the threshold counts (either OVER or UNDER) the
-- state of the filter is updated to the new state.
-- @function update
-- @param value input new value to the filter
-- @return state the current filter state as either UNDER or OVER
-- @usage temperature:update(9.3)  -- apply new value to filter
-- @usage
--   -- apply new value and raise alert if over threshold.
--   if (temperature:update(12) == debounce.OVER) then
--     print("Alert Raised")
--   end
-------------------------------------------------------------------------------
function debounce.update(self, value)

  -- If current state is UNDER, count consecutive over events.
  if (self.state == self.UNDER) then
    if (value > self.threshold) then
	  self.counter = self.counter + 1
	  if (self.counter > self.debOver) then
	    --print("DEBOUNCE:", "OVER",self.counter)
	    self.state = self.OVER
		self.counter = 0
	  end
	else
	  -- reset the counter when an under event occurs
	  self.counter = 0
	end
  else
  -- If current state is OVER, count consecutive under events.
    if (value < self.threshold) then
	  self.counter = self.counter + 1
	  if (self.counter > self.debUnder) then
	    --print("DEBOUNCE:","UNDER",self.counter)
	    self.state = self.UNDER
		self.counter = 0
	  end
	else
	  -- reset the counter when an over event occurs
	  self.counter = 0
    end
  end
  
  return self.state
end

-------------------------------------------------------------------------------
-- Gets the current state of the debounce filter.
-- @function getState
-- @return state the current filter state as either UNDER or OVER
-- @usage
--   if (status:getState() == debounce.OVER) then
--     print("Alert Raised")
--   else
--     print("Alert Cleared")
--   end
-------------------------------------------------------------------------------
function debounce.getState(self)
  return self.state
end

-------------------------------------------------------------------------------
-- Returns true if the filter state is OVER
-- @function isOver
-- @return boolean true if the filter state is OVER
-- @usage if (status:isOver()) then print("Alert Raised") end
-------------------------------------------------------------------------------
function debounce.isOver(self)
  return (self.state == self.OVER)
end

-------------------------------------------------------------------------------
-- Returns true if the filter state is UNDER
-- @function isUnder
-- @return boolean true if the filter state is UNDER
-- @usage if (status:isUnder()) then print("Alert Cleared") end
-------------------------------------------------------------------------------
function debounce.isUnder(self)
  return (self.state == self.UNDER)
end

-------------------------------------------------------------------------------
-- Prints the current state of the filter, including the counter of
-- consecutive events.
-- @function print
-- @usage status:print()
-------------------------------------------------------------------------------
function debounce.print(self)
  print(self.state, self.counter)
end

return debounce