angular.module 'drawing', []
.directive "drawing", ($rootScope)->
  restrict: "A"
  link: (scope, element, attrs) ->

    # variable that decides if something should be drawn on mousemove

    # the last coordinates before the current move
    # Firefox compatibility

    # begins new line

    # get current mouse position

    # set current coordinates to last one

    # stop drawing

    # canvas reset
    reset = ->
      element[0].width = element[0].width
      return

    ctx = element[0].getContext("2d")
    drawing = false
    lastX = undefined
    lastY = undefined
    linePath = []
    scaleRate = 1
    isEnableDrawing = undefined
    lineColorCode = undefined
    lineWidth = undefined

    #methods
    draw = (lX, lY, cX, cY, color = "#4bf", width= 5) ->

      # line from
      ctx.moveTo lX / scaleRate, lY / scaleRate

      # to
      ctx.lineTo cX / scaleRate, cY / scaleRate

      # color
      ctx.strokeStyle = color

      # width
      ctx.lineWidth = width

      # draw it
      ctx.stroke()
      return

    # 监听canvas缩放比例变化消息
    scope.$on 'canvas_scale_rate_changed', (event, newScaleRate)->
      scaleRate = newScaleRate

    # 监听画板开关消息
    scope.$on 'change_is_enabledrawing', (event, newIsEnableDrawing)->
      isEnableDrawing = newIsEnableDrawing

    # 监听画板线条颜色消息
    scope.$on 'change_line_color', (event, newLineColorCode)->
      lineColorCode = newLineColorCode

    # 监听画板线条粗细消息
    scope.$on 'change_line_width', (event, newLineWidth)->
      lineWidth = newLineWidth

    onDown = (event)->
#      if event.offsetX isnt `undefined`
#        lastX = event.offsetX
#        lastY = event.offsetY
#      else
#        lastX = event.layerX - event.currentTarget.offsetLeft
#        lastY = event.layerY - event.currentTarget.offsetTop
      if !isEnableDrawing then return
      lastX = event.offsetX
      lastY = event.offsetY
      ctx.beginPath()
      drawing = true
      #      console.log('ondown ' + lastX + ' ' + lastY)
      linePath = [lastX, lastY]

    onMove = (event)->
      if drawing
        if event.offsetX isnt `undefined`
          currentX = event.offsetX
          currentY = event.offsetY
        else
          currentX = event.layerX - event.currentTarget.offsetLeft
          currentY = event.layerY - event.currentTarget.offsetTop
        draw lastX, lastY, currentX, currentY, lineColorCode, lineWidth

        linePath.push(currentX - lastX, currentY - lastY);
        lastX = currentX
        lastY = currentY

    onUp = (event)->
      drawing = false
      newPath = []
      for i in [0..linePath.length - 1]
        do (i)->
          newPath.push(linePath[i] / scaleRate)

      line =
        path: newPath
        color: lineColorCode
        width: lineWidth
      $rootScope.$broadcast 'draw_line', line
    #      console.log(linePath);
    #      console.log(newPath);

    # 绑定鼠标事件

    element.bind "mousedown", (event) ->
      onDown(event)
      return

    element.bind "mousemove", (event) ->
      onMove(event)
      return

    element.bind "mouseup", (event) ->
      onUp(event)
      return

    # 绑定触摸事件

    element.bind "touchstart", (event) ->
      console.log(event)
      lastX = event.targetTouches[0].pageX + event.layerX
      lastY = event.targetTouches[0].pageY + event.layerY
      ctx.beginPath()
      drawing = true
      console.log('touchstart ' + lastX + ' ' + lastY)
      linePath = [lastX, lastY]
      return

    element.bind "touchmove", (event) ->
      #阻止屏幕滑动
      event.preventDefault()

      if drawing
        currentX = event.targetTouches[0].pageX + event.layerX
        currentY = event.targetTouches[0].pageY + event.layerY
        draw lastX, lastY, currentX, currentY, color, width

        linePath.push(currentX - lastX, currentY - lastY);
        #        linePath.push(lastX, lastY);
        lastX = currentX
        lastY = currentY
      return

    element.bind "touchend", (event) ->
      onUp(event)
      return

    return