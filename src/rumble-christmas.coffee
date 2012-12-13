class SnowGlobe
  constructor : (window)  ->
    @window = window
    @shakeThreshold = 500000
    @fabObjs = {}
    @distanceTop = 0
    @currentTop = 0
    @oldTop = 0
    @distanceLeft = 0
    @currentLeft = 0
    @oldLeft= 0
    @totalDistance = 0
    @currentTimer = null
    @gameOn = false

    @initialise()
     
    @canvas.observe 'object:selected', (e) =>
      unless @gameOn
        @gameOn = true
        @currentTimer = $('.timer').countdown({until: 5, format: 'S', onExpiry: @timerEnd, onTick: @whileTime, compact:true, tickInterval: 0})

    @canvas.observe 'object:moving', (e) =>
      @oldTop = @currentTop
      @oldLeft = @currentLeft
      @currentLeft = e.target.left
      @currentTop = e.target.top
      @distanceLeft += Math.abs(@currentLeft - @oldLeft)
      @distanceTop += Math.abs(@currentTop - @oldTop)
      @totalDistance += @distanceTop + @distanceLeft
      
    @canvas.renderAll()

  initialise: ->
    @setUpCanvas()
    @setMasterGroup()
    @loadAssets()
    @canvas.add(@masterGroup)
    @canvas.renderAll(true)
 
  loadAssets : =>
    getRequests = []
    svgData = [
      'base',
      'groundSnow',
      'nunchucks',
      'mac',
      'conicals',
      'table',
      'simon',  
      'flask',
      'bung',
    ]
    objNum = 0
    for objectName in svgData
      ajaxRequest = $.get "/svg/#{objectName}.svg", (data, textStatus, jqXHR) =>
        queue().defer(fabric.loadSVGFromString, jqXHR.responseText).await (fabObj) =>
          objNum++
          console.log objNum
          console.log objectName
          fabObj = if fabObj.length > 1 then new fabric.Group(fabObj.reverse()) else fabObj[0]
          fabObj.hasBorders = false
          fabObj.hasControls = false
          fabObj.active = true
          fabObj.set('left', 0).set('top', 0)
          @masterGroup.add(fabObj)
          @canvas.renderAll()
          @fabObjs[objNum] = fabObj

        return true
      getRequests.push ajaxRequest

    $.when.apply(null, getRequests).done => @processingComplete()

  setUpCanvas: ->
    @canvas = new fabric.Canvas('canvas', { selection: false})
    @canvas.backgroundColor = '#D0E9F0'
    @setCanvasSize()

  processingComplete: =>
    #console.log 'Loaded!'
    console.log @fabObjs

  setMasterGroup : ->
    @masterGroup = new fabric.Group()
    @masterGroup.hasBorders = false
    @masterGroup.hasControls = false
    @masterGroup.set('width', 178).set('height', 267).scale(2)
    @canvas.centerObject(@masterGroup)

    @canvas.renderAll()

  setCanvasSize : ->
    width = @window.width()
    height = @window.height()
    @canvas.setWidth(width).setHeight(height)

  timerEnd : =>
    @gameOn = false
    console.log "You scored #{@translateScore(@totalDistance)}%"
    @currentTimer.countdown('destroy')
    @resetScore()
    console.log "Finished"
 
  whileTime : =>
    console.log @totalDistance

  resetScore : =>
    @distanceTop = 0
    @currentTop = 0
    @oldTop = 0
    @distanceLeft = 0
    @currentLeft = 0
    @oldLeft = 0
    @totalDistance = 0

  translateScore : (score) =>
    topScore = 10000000
    score/topScore * 100

window?.SnowGlobe = SnowGlobe
    

$ ->
  globe = new SnowGlobe($(window))

