$ ->
	
	@isMouseDown = false
	@isMouseDragged = false
	@currentlySelected = null

	getPixelPosOfObject = (object, axis) ->
		# currentWidth/currentHeight takes into account any scaling on the shape.
		if axis is 'x'
			object.get('left') - (object.get('currentWidth') / 2)
		else if axis is 'y'
			object.get('top') - (object.get('currentHeight') / 2)
		else
			console.log 'No axis defined'


	getPixelPosOfObjectWithinGroup = (object, parentGroup, axis) ->
		if axis is 'x'
			groupScaleX = parentGroup.get('scaleX')
			x = object.get('left') + ((parentGroup.get('width') / 2) - (object.get('width') / 2))
			x = x * groupScaleX
			#console.log "square x value: #{x}"
			x
		else if axis is 'y'
			groupScaleY = parentGroup.get('scaleY')
			y = object.get('top') + ((parentGroup.get('height') / 2) - (object.get('height') / 2))
			y = y * groupScaleY
			#console.log "square y value: #{y}"
			y
		else
			console.log 'No axis defined'



	mouseDownFun = (e) => 
		console.log e.e.layerX
		console.log e
		@isMouseDown = true
		@selectedObj = findObj(e.e.layerX, e.e.layerY)
		if @currentlySelected
			@currentlySelected.obj.set('active', true)

	    
	mouseUpFun = (e) =>
		@isMouseDown = false
		unless @currentlySelected is null
			@currentlySelected.obj.set('active', false)
			@canvas.renderAll()
			@currentlySelected = null	
	    
	mouseMoveFun = (e) =>
		if @isMouseDown and @currentlySelected
			#currentX = @currentlySelected.obj.get('left')
			#currentY = @currentlySelected.obj.get('top')
			#@currentlySelected.obj.set('left', e.e.layerX - ( ( (@currentlySelected.obj.get('width') / 2) + 100 )  + @currentlySelected.selectedAreaX) )
			#@currentlySelected.obj.set('top', e.e.layerY - ( ( (@currentlySelected.obj.get('height') / 2) + 100 )  + @currentlySelected.selectedAreaY) )
			#console.log e.e.layerX
			#console.log @currentlySelected.masterGroupPxPosY
			#console.log @masterGroup.get('currentHeight')/2
			#console.log @currentlySelected.objWidth/2
			#console.log @currentlySelected.selectedAreaX
			masterGroupScaleY = @masterGroup.get('scaleY')
			masterGroupScaleX = @masterGroup.get('scaleX')
			@currentlySelected.obj.set('left', ((e.e.layerX - @currentlySelected.masterGroupPxPosX) - ((@masterGroup.get('currentWidth') / 2) - ((@currentlySelected.objWidth / 2))) - (@currentlySelected.selectedAreaX)) / masterGroupScaleX)
			@currentlySelected.obj.set('top',  ((e.e.layerY - @currentlySelected.masterGroupPxPosY) - ((@masterGroup.get('currentHeight') / 2) - ((@currentlySelected.objHeight / 2))) - (@currentlySelected.selectedAreaY)) / masterGroupScaleY)

			@canvas.renderAll()
			#console.log @currentlySelected
			




		
	hoverFun = (e) =>
		console.log('object Over')
		console.log(e)

	isDrag = (e) =>


	findObj = (mouseX, mouseY) =>

		masterGroupPxPosX = getPixelPosOfObject(@masterGroup, 'x')
		console.log ("masterGroupPxPosX: #{masterGroupPxPosX}")
		masterGroupPxPosY = getPixelPosOfObject(@masterGroup, 'y')
		console.log ("masterGroupPxPosY: #{masterGroupPxPosY}")
		
		for index, obj of @masterGroup.objects
			objWidth = obj.get('width') * @masterGroup.get('scaleX')
			objHeight =  obj.get('height') * @masterGroup.get('scaleY')
			
			pixPosInGroupX =  getPixelPosOfObjectWithinGroup(obj, @masterGroup, 'x')
			pixPosInGroupY =  getPixelPosOfObjectWithinGroup(obj, @masterGroup, 'y')

			pixPosFromCanvasX = pixPosInGroupX + masterGroupPxPosX
			pixPosFromCanvasY = pixPosInGroupY + masterGroupPxPosY

			if isSelected(mouseX, mouseY, pixPosFromCanvasX, pixPosFromCanvasY, objWidth, objHeight)
				@currentlySelected = { 
					obj: obj,
					masterGroup: @masterGroup
					objWidth: objWidth,
					objHeight: objHeight,
					mouseX: mouseX, 
					mouseY: mouseY, 
					selectedAreaX : (mouseX - pixPosFromCanvasX), 
					selectedAreaY : (mouseY - pixPosFromCanvasY), 
					masterGroupPxPosX : masterGroupPxPosX 
					masterGroupPxPosY : masterGroupPxPosY
				}



	isSelected = (mouseX, mouseY, pixPosFromCanvasX, pixPosFromCanvasY, objWidth, objHeight) ->
		if mouseX >= pixPosFromCanvasX and mouseX <= pixPosFromCanvasX + objWidth
			if mouseY >= pixPosFromCanvasY and mouseY <= pixPosFromCanvasY + objHeight
				console.log 'found'
				return true
			else
				return false
		else 
			return false


	dragObj = (obj, top, left) ->



	@canvas = new fabric.Canvas('canvas')
	@canvas.selection = false

	path = "M110.689 661.75q34.0957 0 54.4473 -19.6992q21.8965 -19.7002 21.8965 -55.7695v-220.844l141.281 121l0.34375 -0.40625q20.2031 15.5625 45.7188 15.5625q31.0508 0 53.0254 -21.9746t21.9746 -53.0254q0 -21.0391 -10.7559 -38.6787 q-10.7559 -17.6387 -28.6504 -27.3213l-91.0312 -78.6875l135.438 -166.781q13.5 -16.624 13.5 -43.625q-0.00195312 -31.0518 -21.9746 -53.0254q-21.9746 -21.9746 -53.0254 -21.9746q-35.0371 0 -57.5625 26.9688l-130.469 159.812l-17.8125 -15.375v-93.0625 q0 -30.8301 -20.5332 -51.9619t-54.7168 -21.1318q-32.5996 0 -53.1895 20.2246q-20.5938 20.2256 -20.5938 50.9316v510.5q0 32.3896 20.375 55.3672q20.375 22.9766 52.3145 22.9766z"

	#newPath = new fabric.Path(path)
	rect = new fabric.Rect()
	rect2 = new fabric.Rect()
	rect3 = new fabric.Rect()
	rect4 = new fabric.Rect()
	rect5 = new fabric.Rect()
	@masterGroup = new fabric.Group()
	#newPath.set('top', 0)
	#newPath.set('left', 0)
	#newPath.set('stroke', '#000000')
	#newPath.set('strokeWidth', 1)
	#newPath.set('fill', 'red')
	#newPath.scale(0.30)

	@masterGroup.set('width', 400)
	@masterGroup.set('height', 400)
	@masterGroup.set('top',400)
	@masterGroup.set('left',400)
	@masterGroup.set('selectable', false)
	@masterGroup.set('strokeWidth', 1)
	@masterGroup.set('stroke', 'black')

	@masterGroup.scale(1)

	      
	rect.set 'fill', 'red' 
	rect.set 'width', 100
	rect.set 'height', 100 
	rect.set 'left', 0
	rect.set 'top', 0

	rect2.set 'fill', 'black'
	rect2.set 'width', 50
	rect2.set 'height', 50
	rect2.set 'left', 25
	rect2.set 'top', 25

	rect3.set 'fill', 'blue' 
	rect3.set 'width', 50
	rect3.set 'height', 70 
	rect3.set 'left', 20
	rect3.set 'top', 40

	rect4.set 'fill', 'yellow' 
	rect4.set 'width', 100
	rect4.set 'height', 150 
	rect4.set 'left', -50
	rect4.set 'top', -50

	rect4.set 'fill', 'orange' 
	rect4.set 'width', 25
	rect4.set 'height', 25
	rect4.set 'left', -300
	rect4.set 'top', -300


	#@masterGroup.add(newPath)
	

	@masterGroup.add(rect).add(rect2).add(rect3).add(rect4).add(rect5)
	@canvas.add(@masterGroup)
	@masterGroup.center()
	

	#newPath.set('selectable', true)
	#newPath.set('active', true)
	#newPath.set('hasControls', false)

	@canvas.observe('mouse:down', mouseDownFun)
	@canvas.observe('mouse:up', mouseUpFun)
	@canvas.observe('mouse:move', mouseMoveFun)
	@canvas.observe('object:over', hoverFun)

	@canvas.renderAll()

	console.log @canvas

