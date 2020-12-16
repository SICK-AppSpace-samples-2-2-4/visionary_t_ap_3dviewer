--[[----------------------------------------------------------------------------
                                                                                                                                                                                            
  Showing the pointcloud converted from Visionary-T AP data.

------------------------------------------------------------------------------]]
-- Setup the camera
local camera = Image.Provider.Camera.create()
local cameraModel = Image.Provider.Camera.getInitialCameraModel(camera)

-- Setup the pointcloud converter
local pointCloudConverter = Image.PointCloudConverter.create(cameraModel)

-- Setup the  view
local v3D = View.create('3DViewer')

local function main()
  -- Start the camera, note that camera is never stopped in this sample
  camera:start()
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--@handleOnNewImage(image:Image, sensordata:SensorData)
local function handleOnNewImage(image)
  -- First argument is the distance image, second one is the intensity image
  local pointCloud = pointCloudConverter:convert(image[1], image[2])

  -- Add the point cloud data to the view
  v3D:addPointCloud(pointCloud)

  -- Present the point cloud
  v3D:present()
end
-- Registration of the 'handleOnNewImage' function to the cameras "OnNewImage" event
Image.Provider.Camera.register(camera, 'OnNewImage', handleOnNewImage)
