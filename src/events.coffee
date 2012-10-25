$ ->
	
	@isMouseDown = false
	@isMouseDragged = false
	@currentlySelected = null

	mouseDownFun = (e) => 
		@isMouseDown = true
		@selectedObj = findObj(e.e.x, e.e.y)
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
			left = @currentlySelected.obj.get('left')
			console.log left
			top = @currentlySelected.obj.get('top')
			console.log top
			@currentlySelected.obj.set('left', e.e.x - ( 300 )) 
			@currentlySelected.obj.set('top', e.e.y - ( 300  ))

			@canvas.renderAll()
			console.log @currentlySelected
			




		
	hoverFun = (e) =>
		console.log('object Over')
		console.log(e)

	isDrag = (e) =>


	findObj = (mouseX, mouseY) =>

		masterGroupWidth = @masterGroup.get('width')
		masterGroupHeight = @masterGroup.get('height')

		masterGroupX = @masterGroup.get('left') - (masterGroupWidth / 2)
		masterGroupY = @masterGroup.get('top') - (masterGroupHeight / 2)
		
		for index, obj of @masterGroup.objects
			objWidth = obj.get('width')
			#console.log "width #{objWidth}"
			objHeight =  obj.get('height')
			#console.log "height #{objHeight}"
			top = obj.get('top')
			left = obj.get('left')
			newPositionX =  ((masterGroupWidth / 2) - (obj.get('width') / 2)) + left
			newPositionY =  ((masterGroupHeight / 2) - (obj.get('height') / 2)) + top

			objPosX = newPositionX + masterGroupX
			objPosY = newPositionY + masterGroupY
			#console.log "offset left #{objPosX}"
			#console.log "offst top #{objPosY}"
			if isSelected(mouseX, mouseY, objPosX, objPosY, objWidth, objHeight)
				console.log "newPositionY: #{newPositionY}"
				#console.log "you chose: #{obj}"
				@currentlySelected = { obj: obj, mouseX: mouseX, mouseY: mouseY, selectedAreaX : mouseX - objPosX, selectedAreaY : mouseY - objPosY }



	isSelected = (mouseX, mouseY, objPosX, objPosY, objWidth, objHeight) ->
		if mouseX >= objPosX and mouseX <= objPosX + objWidth
			if mouseY >= objPosY and mouseY <= objPosY + objHeight
				return true
			else
				return false
		else 
			return false


	dragObj = (obj, top, left) ->



	@canvas = new fabric.Canvas('canvas')
	@canvas.selection = false

	path = "M110.689 661.75q34.0957 0 54.4473 -19.6992q21.8965 -19.7002 21.8965 -55.7695v-220.844l141.281 121l0.34375 -0.40625q20.2031 15.5625 45.7188 15.5625q31.0508 0 53.0254 -21.9746t21.9746 -53.0254q0 -21.0391 -10.7559 -38.6787 q-10.7559 -17.6387 -28.6504 -27.3213l-91.0312 -78.6875l135.438 -166.781q13.5 -16.624 13.5 -43.625q-0.00195312 -31.0518 -21.9746 -53.0254q-21.9746 -21.9746 -53.0254 -21.9746q-35.0371 0 -57.5625 26.9688l-130.469 159.812l-17.8125 -15.375v-93.0625 q0 -30.8301 -20.5332 -51.9619t-54.7168 -21.1318q-32.5996 0 -53.1895 20.2246q-20.5938 20.2256 -20.5938 50.9316v510.5q0 32.3896 20.375 55.3672q20.375 22.9766 52.3145 22.9766z"

	newPath = new fabric.Path(path)
	rect = new fabric.Rect()
	@masterGroup = new fabric.Group()
	newPath.set('top', 0)
	newPath.set('left', 0)
	newPath.set('stroke', '#000000')
	newPath.set('strokeWidth', 1)
	newPath.set('fill', 'red')
	newPath.scale(0.30)

	@masterGroup.set('width', 600)
	@masterGroup.set('height', 600)
	@masterGroup.set('top', 300)
	@masterGroup.set('left', 300)
	@masterGroup.set('selectable', false)
	@masterGroup.set('strokeWidth', 1)
	@masterGroup.set('stroke', 'black')
	      
	rect.set('fill', 'red')
	rect.set('width', 100)
	rect.set('height', 100)
	rect.set('left', 0)
	rect.set('top', 0)

	#@masterGroup.add(newPath)
	@masterGroup.add(rect)
	@canvas.add(@masterGroup)

	newPath.set('selectable', true)
	newPath.set('active', true)
	newPath.set('hasControls', false)

	@canvas.observe('mouse:down', mouseDownFun)
	@canvas.observe('mouse:up', mouseUpFun)
	@canvas.observe('mouse:move', mouseMoveFun)
	@canvas.observe('object:over', hoverFun)

	@canvas.renderAll()

	console.log @canvas

