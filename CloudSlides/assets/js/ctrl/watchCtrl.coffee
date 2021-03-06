angular.module 'watchCtrl', ['User', 'Meeting', 'UAService']
.controller 'watchCtrl', ($scope, $stateParams, UAService, User, Meeting)->
  # 私有函数

  # 绘制页码图片
  drawPageImage = (pageId)->
    pageCanvas = document.getElementById('pageCanvas')
    ctx = pageCanvas.getContext("2d")
    canvasWrapperWidth = $('#canvas-wrapper').width()

    # 获取对应image对象
    img = document.getElementById('page' + pageId)

    # 根据图像大小和画布总尺寸调整canvas画布大小
    hgtWidRate = img.height / img.width

    if img.width > canvasWrapperWidth
      pageCanvas.width = canvasWrapperWidth
    else
      pageCanvas.width = img.width

    pageCanvas.height = pageCanvas.width * hgtWidRate

    # 缩放画布大小
    $scope.scaleRate = pageCanvas.width / img.width
    ctx.scale($scope.scaleRate, $scope.scaleRate)

    # 将图形绘入canvas
    ctx.drawImage(img, 0, 0)

    # 已绘制
    $scope.isCurrentPageDrawed = true


  # 画布绘线
  drawLine = (linePath, lineColor = '#4bf', lineWidth = 6)->
    pageCanvas = document.getElementById('pageCanvas')
    ctx = pageCanvas.getContext("2d")
    ctx.beginPath()
    lastX = linePath[0]
    lastY = linePath[1]
    ctx.moveTo(lastX, lastY)
    for i in [2.. linePath.length - 1] by 2
      do (i)->
        currentX = lastX + linePath[i]
        currentY = lastY + linePath[i + 1]
        ctx.lineTo(currentX, currentY)
        lastX = currentX
        lastY = currentY
    ctx.lineWidth = lineWidth
    ctx.strokeStyle = lineColor
    ctx.stroke()


  # 初始化
  init = ()->
    $scope.meetingId = $stateParams.meetingId
    $scope.currentPageId = 1 #默认显示第一页
    $scope.maxPageId = 1
    $scope.isCurrentPageDrawed = false # 当前页码未绘图
    $scope.scaleRate = 1 # canvas画布缩放比例
    $scope.isDownGraded = UAService.isDownGraded()
    $scope.refreshMeetingData($scope.meetingId)
    initSubscribe($scope.meetingId)


  # 公有函数

  # 监听窗口大小变化
  $(window).on('resize', (e)->
    drawPageImage($scope.currentPageId)
  )

  # 监听会议数据加载完成消息
  $scope.$on 'meeting_data_loaded', ()->
    $scope.maxPageId = $scope.meeting.ppt.pageCount
    # 开始监听图片加载完成消息
    $scope.readyPageImagesId = []
    $scope.$on 'page_image_loaded', (event, pageId)->
      $scope.readyPageImagesId.push(pageId)

      # 加载完成的页码与当前页码匹配 且未绘制
      if pageId == $scope.currentPageId and !$scope.isCurrentPageDrawed
        drawPageImage(pageId)

  # 刷新数据
  $scope.refreshMeetingData = (meetingId)->
    console.log('refreshMeetingData')
    $scope.meeting = {}
    Meeting.get(
      id: $scope.meetingId
    ,
      #onSuccess
      (value, responseHeaders)->
        $scope.meeting = value
        $scope.pageRange = [1..$scope.meeting.ppt.pageCount]

        # 广播会议数据加载完成消息
        $scope.$broadcast('meeting_data_loaded')
    ,
      #onError
      (httpResponse)->
        console.log(httpResponse)
    )

  $scope.$on 'updatePage', (a, pageId)->
    $scope.currentPageId = pageId
    drawPageImage(pageId)
    $scope.$apply()

  $scope.$on 'drawLine', (event, line)->
    drawLine(line.path, line.color, line.width)

  # 订阅会议实时消息
  initSubscribe = (meetingId)->
    io.socket.on 'meeting', (obj)->
      if obj.verb is 'messaged'
        if obj.data.type == 'updatePage'
          pageId = parseInt(obj.data.pageId)
          $scope.$broadcast('updatePage', pageId)
        else
          if obj.data.type == 'drawLine'
            line = JSON.parse(obj.data.line)
            # console.log(line)
            $scope.$broadcast 'drawLine', line
            return

    # 订阅当前会议
    io.socket.get('/meeting/subscribeWatch',
      meetingId: meetingId
    )

    return true

  #初始化
  init()
