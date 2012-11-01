class TextToPath

  constructor : (@$, @fabric, @canvas, properties = "") -> 
    @_mergeProperties(properties)
    @_setText()


  defaultProperties : {
    fontSize : 50,
    letterSpacing : 0,
    fill : "#000000",
    stroke : "none",
    strokeWidth : 0,
    text: undefined,
    fontFamily: undefined,
    fontData: undefined,
    angle: 0,
    top: 0,
    left: 0
  } 

  _setText : =>
    if @fabricGroup then @canvas.remove(@fabricGroup)
    @_splitString()
    @_createTextObject()
    @_buildFabricEles()
    @canvas.renderAll()


  _splitString : ->
    #returns an array
    @splitText = []
    for char, index in @customProperties.text.split ''
      @splitText.push(char)
    return @splitText


  _buildMeta : ->
    @textObj.meta = {
      fontFamily : @$(@customProperties.fontData).find("font-face").attr("font-family")
      unitsPerEm : parseInt(@$(@customProperties.fontData).find("font-face").attr("units-per-em"), 10)
      defaultCharWidth : parseInt(@$(@customProperties.fontData).find("font").attr("horiz-adv-x"), 10)
      ascent : parseInt(@$(@customProperties.fontData).find("font-face").attr("ascent"), 10)
    }


  _buildGlyphs : ->
    @textObj.glyphs = []
    @splitText.forEach (item, i) =>

      glyphEquiv = @$(@customProperties.fontData).find("[unicode='#{item}']")
      #console.log glyphEquiv
      if glyphEquiv.length == 0
      #char doesn't exist use missing glyph instead
        glyphEquiv = @$(@customProperties.fontData).find("missing-glyph")

      @textObj.glyphs.push {
        name : glyphEquiv.attr("glyph-name"),
        unicode : glyphEquiv.attr("unicode"),
        path : glyphEquiv.attr("d"),
        width : @_findCharWidth(glyphEquiv) 
      }

  
  # Checks if the horiz-adv-x attribute exists, 
  # if not it falls back to the global horiz-adv-x
  _findCharWidth : (glyphEquiv) ->
    if glyphEquiv.attr("horiz-adv-x") == undefined
      @textObj.meta.defaultCharWidth
    else
      parseInt(glyphEquiv.attr("horiz-adv-x"), 10) 

  
  _calculateKerning : ->
    for obj, index in @textObj.glyphs
      unless index == @textObj.glyphs.length - 1
        kernEle = @$("hkern[u1='#{obj.unicode}']").filter("[u2='#{@textObj.glyphs[index + 1].unicode}']")
        if @customProperties.letterSpacing > 0 or @customProperties.letterSpacing < 0
            obj.width = obj.width + @_calcScale(@customProperties.letterSpacing)
        if kernEle.length > 0
          obj.width = obj.width - parseInt(kernEle.attr('k'), 10)

      
  _createTextObject : ->
    @textObj = {}
    @_buildMeta()
    @_buildGlyphs()
    @_calculateKerning()
    return @textObj


  _buildFabricEles : ->
    xAdvance = 0
    @fabricGroup = new fabric.Group()
    @fabricGroup.set('height', @textObj.meta.ascent)
    .set('top', @customProperties.top)
    .set('left', @customProperties.left)
    .scale(@_calcFontScale())
    for obj, index in @textObj.glyphs
      unless obj.path == undefined or obj.path == ''
        newLine = new fabric.Path(obj.path)
        unless @customProperties.strokeWidth is 0
          newLine.set('strokeWidth', @_calcScale(@customProperties.strokeWidth))
          newLine.set('stroke', @customProperties.stroke)
        newLine.set('fill', @customProperties.fill)
        newLine.set('top', 0)        
        newLine.set('width', obj.width)
        newLine.set('height', @textObj.meta.ascent)
        newLine.set('left', (xAdvance + (obj.width / 2)))
        newLine.set('scaleY', -1)
        @fabricGroup.add(newLine)
        xAdvance = xAdvance + obj.width
        @canvas.renderAll()
      else #any character space
        xAdvance = xAdvance + obj.width
        @canvas.renderAll()
    @fabricGroup.set('width', xAdvance)
    
    offset = xAdvance / 2
    for obj, index in @fabricGroup.objects
      obj.set('left', obj.left - offset)

    @fabricGroup.setAngle(@customProperties.angle)
    #console.log @fabricGroup
    return @fabricGroup

    
  _calcFontScale : ->
    @customProperties.fontSize / @textObj.meta.unitsPerEm

  _ascenderToEmSquarePercent : ->
    (@textObj.meta.ascent / @textObj.meta.unitsPerEm ) * 100
  
  _calcScale : (sizeInPixels) ->
    sizeInPixels * @textObj.meta.unitsPerEm / @customProperties.fontSize
  
  _mergeProperties : (properties) ->
    @customProperties = @$.extend({}, @defaultProperties, properties)



  ## Public Methods

  # Setters

  render: ->
    @canvas.remove(@fabricGroup)
    @canvas.add(@fabricGroup)
    @canvas.renderAll()


  fill : (fillcolor) ->
    @customProperties.fill = fillcolor
    @_setText()


  stroke : (newStroke) ->
    @customProperties.stroke = newStroke
    @_setText()


  strokeWidth : (newStrokeWidth) ->
    @customProperties.strokeWidth = newStrokeWidth
    @_setText()


  letterSpacing : (newLetterSpacing) ->
    @customProperties.letterSpacing = newLetterSpacing
    @_setText()

  
  fontSize : (newFontSize) ->
    @customProperties.fontSize = newFontSize
    @_setText()


  text : (newText) ->
    @customProperties.text = newText
    @_setText()


  fontData : (newFont) ->
    @customProperties.fontData = newFont
    @_setText()

  
  top : (newTop) ->
    @customProperties.top = newTop
    @_setText()

  
  left : (newLeft) ->
    @customProperties.left = newLeft
    @_setText()

  angle : (newAngle) ->
    @customProperties.angle = newAngle
    @_setText()

  removeInstance : ->
    @canvas.remove(@fabricGroup)
    @canvas.renderAll()


  # Getters
  
  getFabObj : ->
    @fabricGroup



module?.exports = TextToPath 
window?.TextToPath = TextToPath