--[[----------------------------------------------------------------------------

  Application Name:
  ImagePlayer

  Summary:
  Viewing images provided from resources in specific user interface using the
  2D viewer available as a Package. Meta information is printed to console.

  Script creates an ImageProvider which reads bitmap images from the 'resources'
  folder. This Provider takes images with a period 1000ms, which are provided
  asynchronously to the handleNewImage function.
  To demo this script the emulator can be used. The image is being displayed in
  the 2D viewer on the webpage (localhost 127.0.0.1) and the meta data is logged
  to the console.

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

local IMAGE_PATH = 'resources/'

-- Create an ImageDirectoryProvider
local handle = Image.Provider.Directory.create()
-- Define the path from which the provider gets images
Image.Provider.Directory.setPath(handle, IMAGE_PATH)
-- Set the a cycle time of 500ms
Image.Provider.Directory.setCycleTime(handle, 1000)

-- create a viewer instance
local viewer = View.create()
View.setID(viewer, 'viewer2D')

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
  View.view(viewer, img)
end
-- Register the callback function
Image.Provider.Directory.register(handle, 'OnNewImage', handleNewImage)

--End of Function and Event Scope------------------------------------------------
