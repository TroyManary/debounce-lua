package.path = package.path .. ';..\\?.lua'
debounce = require"debounce"
local threshold = 10
local debOver = 5
local debUnder = 3

local data = {}
local result
local testPass = true
local debFilter = debounce.new(threshold,debUnder,debOver)

file = arg[1] or "dataFile.txt"
autoVerify = arg[2] or false

dataFile = io.open(file, "r")
if (autoVerify) then
  resultFile = io.open("resultFile.txt", "r")
end

repeat
  str = dataFile:read()
  if str then
    local i=0
    for val in string.gmatch(str, '([^ ]+)') do
	  data[i] = tonumber(val)
	  i=i+1
	end
    result = debFilter:update(data[0])
	if (autoVerify) then
	  resultStr = resultFile:read()
	  expectedResult = (resultStr == "true")
	  if (expectedResult ~= result) then
		print("Test Failed: Result=", result," Expected:",resultStr)
		testPass = false
	  end
	else
	  print(result)
	end
  end
until not str
if (autoVerify and testPass) then
    print("Test Passed")
end
	
