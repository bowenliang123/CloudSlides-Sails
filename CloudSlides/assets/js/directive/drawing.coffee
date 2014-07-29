angular.module 'drawing',[]
.directive "drawing", ->
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
    draw = (lX, lY, cX, cY, color="#4bf") ->

      # line from
      ctx.moveTo lX, lY

      # to
      ctx.lineTo cX, cY

      # color
      ctx.strokeStyle = color

      # draw it
      ctx.stroke()
      return
    ctx = element[0].getContext("2d")
    drawing = false
    lastX = undefined
    lastY = undefined
    element.bind "mousedown", (event) ->
      if event.offsetX isnt `undefined`
        lastX = event.offsetX
        lastY = event.offsetY
      else
        lastX = event.layerX - event.currentTarget.offsetLeft
        lastY = event.layerY - event.currentTarget.offsetTop
      ctx.beginPath()
      drawing = true
      return

    element.bind "mousemove", (event) ->
      if drawing
        if event.offsetX isnt `undefined`
          currentX = event.offsetX
          currentY = event.offsetY
        else
          currentX = event.layerX - event.currentTarget.offsetLeft
          currentY = event.layerY - event.currentTarget.offsetTop
        draw lastX, lastY, currentX, currentY
        lastX = currentX
        lastY = currentY
      return

    element.bind "mouseup", (event) ->
      drawing = false
      return


#    scope.$watch attrs.pageId, (pageId)->
#      console.log(pageId);
#      img = new Image();
#      img.src=imageUrl;
#      img.onload = ()->
#      ctx.drawImage($('#page'+pageId),0,0);

    return