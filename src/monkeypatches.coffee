fabric = window?.fabric or require('fabric').fabric

# Rumble monkey patch for fabric
# Allow loading an image from an base64
# string.
fabric.Image.fromBase64 = (imgOptions) ->
  img = fabric.document.createElement('img')
  img.src = imgOptions.src
  fabricImage = new fabric.Image(img, imgOptions)

  # Override 'set' to allow us to do image.set('src', 'base64 string...')
  # just to keep the implementation simple in the controller
  fabricImage.set = (name, val) ->
    if name == 'src'
      ele = fabricImage.getElement()
      ele.src = val
      fabricImage.setElement(ele)
    # Call prototype...
    fabric.Image.prototype.set.call(@, name, val)
  fabricImage


## Center a group easily
fabric.util.centerGroup = (canvas, masterGroup) ->
  canvas.centerObjectH(masterGroup).centerObjectV(masterGroup)


## Gets Aspect Ratio of an object
fabric.util.getAspectRatio = (obj) ->
  # aspect ratio = shape width / height
  objWidth = fabric.util.getObjSize(obj, 'x')
  objHeight = fabric.util.getObjSize(obj, 'y')
  aspectRatio = objWidth/objHeight


## Works out best fit for the mastergroup on the
## Available canvas space
fabric.util.groupResize = (canvas, masterGroup, percentageSize) ->
  canvasAspectRatio = fabric.util.getAspectRatio(canvas)
  masterGroupAspectRatio = fabric.util.getAspectRatio(masterGroup)
  # logic to determine how group will be resized in
  # retaion to the siz eof the canvas
  if canvasAspectRatio > 1 and masterGroupAspectRatio > 1
    # Both are landscape
    if masterGroupAspectRatio > canvasAspectRatio
      canvasWidth = canvas.getWidth()
      masterGroup.scaleToWidth(canvasWidth/100 * percentageSize)
    else
      canvasHeight = canvas.getHeight()
      masterGroup.scaleToHeight(canvasHeight/100 * percentageSize)
  else if canvasAspectRatio < 1 and masterGroupAspectRatio < 1
    # Both are potrait
    if masterGroupAspectRatio < canvasAspectRatio
      canvasHeight = canvas.getHeight()
      masterGroup.scaleToHeight(canvasHeight/100 * percentageSize)
    else
      canvasWidth = canvas.getWidth()
      masterGroup.scaleToWidth(canvasWidth)
  else if canvasAspectRatio < 1 and masterGroupAspectRatio > 1
    # Canvas is portrait, group is landscape
    canvasWidth = canvas.getWidth()
    masterGroup.scaleToWidth(canvasWidth/100 * percentageSize)
  else if canvasAspectRatio > 1 and masterGroupAspectRatio < 1
    # Canvas is lanscape, group is portrait
    canvasHeight = canvas.getHeight()
    masterGroup.scaleToHeight(canvasHeight/100 * percentageSize)
  else if canvasAspectRatio = 1 and masterGroupAspectRatio < 1
    # Canvas is Square, group and is portrait
    canvasHeight = canvas.getHeight()
    masterGroup.scaleToHeight(canvasHeight/100 * percentageSize)
  else if canvasAspectRatio = 1 and masterGroupAspectRatio >= 1
    # Canvas is Square, group and is landscape or square
    canvasWidth = canvas.getWidth()
    masterGroup.scaleToWidth(canvasWidth/100 * percentageSize)

## Check if scaling has resulted in the group being scaled to larger
## than 100% of it's realworld size. Scale down to max size if it is
fabric.util.constrainComponentSize = (canvas, masterGroup) ->
  currentWidth = masterGroup.currentWidth
  currentHeight = masterGroup.currentHeight
  maxWidth = masterGroup.width
  maxHeight = masterGroup.height
  if currentWidth > maxWidth || currentHeight > maxHeight
    widthDif = currentWidth - maxWidth
    heightDif = currentHeight - maxHeight
    if widthDif > heightDif
      masterGroup.scaleToWidth(maxWidth)
    else
      masterGroup.scaleToHeight(maxHeight)
    fabric.util.centerGroup(canvas, masterGroup)


## Resize a canvas 
fabric.util.canvasResize = (canvas, isEditor = true, width = null, height = null) ->
  if isEditor
    propertyPanelWidth = 240
    headerBarHeight = 80
    windowHeight = $(window).height()
    windowWidth = $(window).width()
    canvasHeight = windowHeight - headerBarHeight 
    calcHeight = canvasHeight
    calcWidth = windowWidth - propertyPanelWidth
  else    
    calcHeight = height
    calcWidth = width
  canvas.setWidth(calcWidth)
  canvas.setHeight(calcHeight) 


fabric.util.getOffsetPosition = (obj, shape, newPosition, axis) ->
  shapeSize = fabric.util.getObjSize(shape, axis)
  objSize = fabric.util.getObjSize(obj, axis)

  if axis == 'x'
    shapeCentreX = shapeSize / 2
    xPosition = (newPosition - shapeCentreX) + (objSize / 2)
  else if axis == 'y'
    shapeCentreY = shapeSize / 2
    yPosition = (newPosition - shapeCentreY) + (objSize / 2)



fabric.util.getObjSize = (obj, axis) ->
  if obj instanceof fabric.PathGroup
    if axis == 'x'
      size = obj.paths[0].getWidth()
      # Must take scaling into consideration to get correct Width and Height
      if obj.scaleX
        size = obj.scaleX * size
      else
        size
    else if axis == 'y'
      size = obj.paths[0].getHeight()
      if obj.scaleY
        size = obj.scaleY * size
      else
        size
  else if obj.objects != undefined and obj.objects[0] instanceof fabric.PathGroup
    if axis == 'x'
      size = obj.objects[0].paths[0].getWidth()
    else if axis == 'y'
      size = obj.objects[0].paths[0].getHeight() 
  else
    if axis == 'x'
      size = obj.getWidth()
    else if axis == 'y'
      size = obj.getHeight()


