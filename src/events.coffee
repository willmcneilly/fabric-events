$ ->
	
	@isMouseDown = false
	@isMouseDragged = false
	@currentlySelected = null

	getPixelPosOfObject = (object, axis) ->
		if axis is 'x'
			object.get('left') - (object.get('width') / 2)
		else if axis is 'y'
			object.get('top') - (object.get('height') / 2)
		else
			console.log 'No axis defined'


	getPixelPosOfObjectWithinGroup = (object, parentGroup, axis) ->
		if axis is 'x'
			object.get('left') + ((parentGroup.get('width') / 2) - (object.get('width') / 2)) 
		else if axis is 'y'
			object.get('top') + ((parentGroup.get('height') / 2) - (object.get('height') / 2)) 
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
			currentX = @currentlySelected.obj.get('left')
			currentY = @currentlySelected.obj.get('top')
			#@currentlySelected.obj.set('left', e.e.layerX - ( ( (@currentlySelected.obj.get('width') / 2) + 100 )  + @currentlySelected.selectedAreaX) )
			#@currentlySelected.obj.set('top', e.e.layerY - ( ( (@currentlySelected.obj.get('height') / 2) + 100 )  + @currentlySelected.selectedAreaY) )
			console.log e.e.layerX
			console.log @currentlySelected.masterGroupY
			@currentlySelected.obj.set('left', (e.e.layerX - @currentlySelected.masterGroupX) - ((@currentlySelected.masterGroup.get('width') / 2) - (@currentlySelected.objWidth/2)) - @currentlySelected.selectedAreaX)
			@currentlySelected.obj.set('top',  (e.e.layerY - @currentlySelected.masterGroupY) - ((@currentlySelected.masterGroup.get('height') / 2) - (@currentlySelected.objHeight/2)) - @currentlySelected.selectedAreaY)

			@canvas.renderAll()
			console.log @currentlySelected
			




		
	hoverFun = (e) =>
		console.log('object Over')
		console.log(e)

	isDrag = (e) =>


	findObj = (mouseX, mouseY) =>

		masterGroupX = getPixelPosOfObject(@masterGroup, 'x')
		console.log ("masterGroupX: #{masterGroupX}")
		masterGroupY = getPixelPosOfObject(@masterGroup, 'y')
		console.log ("masterGroupY: #{masterGroupY}")
		
		for index, obj of @masterGroup.objects
			objWidth = obj.get('width')
			objHeight =  obj.get('height')
			
			XPositionInGroup =  getPixelPosOfObjectWithinGroup(obj, @masterGroup, 'x')
			YPositionInGroup =  getPixelPosOfObjectWithinGroup(obj, @masterGroup, 'y')

			objPosX = XPositionInGroup + masterGroupX
			objPosY = YPositionInGroup + masterGroupY

			if isSelected(mouseX, mouseY, objPosX, objPosY, objWidth, objHeight)
				@currentlySelected = { 
					obj: obj,
					masterGroup: @masterGroup
					objWidth: objWidth,
					objHeight: objHeight,
					mouseX: mouseX, 
					mouseY: mouseY, 
					selectedAreaX : (mouseX - objPosX), 
					selectedAreaY : (mouseY - objPosY), 
					masterGroupX : masterGroupX, 
					masterGroupY : masterGroupY 
				}



	isSelected = (mouseX, mouseY, objPosX, objPosY, objWidth, objHeight) ->
		if mouseX >= objPosX and mouseX <= objPosX + objWidth
			if mouseY >= objPosY and mouseY <= objPosY + objHeight
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
	      
	rect.set('fill', 'red')
	rect.set('width', 100)
	rect.set('height', 100)
	rect.set 'left', 0
	rect.set 'top', 0

	rect2.set 'fill', 'black'
	rect2.set 'width', 50
	rect2.set 'height', 50
	rect2.set 'left', 25
	rect2.set 'top', 25

	#@masterGroup.add(newPath)
	
	@canvas.add(rect2)
	@masterGroup.add(rect)
	@canvas.add(@masterGroup)
	

	#newPath.set('selectable', true)
	#newPath.set('active', true)
	#newPath.set('hasControls', false)

	@canvas.observe('mouse:down', mouseDownFun)
	@canvas.observe('mouse:up', mouseUpFun)
	@canvas.observe('mouse:move', mouseMoveFun)
	@canvas.observe('object:over', hoverFun)

	@canvas.renderAll()

	console.log @canvas

