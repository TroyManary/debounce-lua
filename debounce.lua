local debounce = {}
debounce.__index = debounce

debounce.UNDER = false
debounce.OVER = true

-------------------------------------------------------------------------------
-- Debounce Constructor
--
-- Instantiates a debounce filter with the following configurations:
--   threshold: 
--   debUnder:
--   debOver
-------------------------------------------------------------------------------
function debounce.new(threshold, debUnder, debOver )
  local self = setmetatable({}, debounce)
  self.threshold = threshold
  self.debUnder = debUnder
  self.debOver = debOver
  self.state = debounce.UNDER
  self.counter = 0
 return self
end

-------------------------------------------------------------------------------
-- Debounce Reset
--
-- Resets to a known state.
-- Does not alter the filter configuration.
-- If a value is specified, it is compared to the threshold and sets the state
-- appropriately (with no consideration for existing debounce counter)
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
-- Debounce Update
--
-- Updates the state of the filter based on the new value.
-------------------------------------------------------------------------------
function debounce.update(self, value)
  if (self.state == self.UNDER) then
    if (value > self.threshold) then
	  self.counter = self.counter + 1
	  if (self.counter > self.debOver) then
	    self.state = self.OVER
		self.counter = 0
	  end
	end
  else
    if (value < self.threshold) then
	  self.counter = self.counter + 1
	  if (self.counter > self.debUnder) then
	    self.state = self.UNDER
		self.counter = 0
	  end
    end
  end
  
  return self.state
end

function debounce.getState(self)
  return self.state
end

function debounce.isOver(self)
  return (self.state == self.OVER)
end

function debounce.isUnder(self)
  return (self.state == self.UNDER)
end

function debounce.print(self)
  print(self.state)
end

return debounce