
--Start of Global Scope---------------------------------------------------------

local IMAGE_PATH = 'resources/'

-- Create an ImageDirectoryProvider
local handle = Image.Provider.Directory.create()
-- Define the path from which the provider gets images
Image.Provider.Directory.setPath(handle, IMAGE_PATH)
-- Set the a cycle time of 500ms
Image.Provider.Directory.setCycleTime(handle, 1000)

-- create a viewer instance
local viewer = View.create("viewer2D1")

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

--Declaration of the 'main' function as an entry point for the event loop
--@main()
local function main()
  -- Starting provider after Engine.OnStarted event was received
  local success = Image.Provider.Directory.start(handle)
  if success then
    print('ImagePlayer successfully started.')
  else
    print('ImagePlayer could not be started.')
  end
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

local function handleNewImage(img, sensorData)
  -- get the timestamp from the metadata
  local timeStamp = SensorData.getTimestamp(sensorData)
  -- get the filename from the metadata
  local origin = SensorData.getOrigin(sensorData)

  -- get the dimensions from the image
  local width,
    height = Image.getSize(img)
  local str = string.format("Image '%s': ts = %s ms, width = %s , height = %s", origin, timeStamp, width, height)
  print(str)
  -- present the image in the image viewer
  View.addImage(viewer, img)
  View.present(viewer)
end
-- Register the callback function
Image.Provider.Directory.register(handle, 'OnNewImage', handleNewImage)

--End of Function and Event Scope------------------------------------------------
