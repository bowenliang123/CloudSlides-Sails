angular.module 'watchCtrl', ['User', 'Meeting']
.controller 'watchCtrl', ($scope, $rootScope, $stateParams, User, Meeting)->
  #私有变量
  pageCanvas = document.getElementById('pageCanvas')
  ctx = pageCanvas.getContext("2d")

  #绘制页码图片
  drawPageImage = (pageId)->
    pageCanvas = document.getElementById('pageCanvas')
    ctx = pageCanvas.getContext("2d")
    canvasWrapperWidth = $('#canvas-wrapper').width()

    #获取对应image对象
    img = document.getElementById('page' + pageId)

    #根据图像大小和画布总尺寸调整canvas画布大小
    hgtWidRate = img.height / img.width

    if img.width > canvasWrapperWidth
      pageCanvas.width = canvasWrapperWidth
    else
      pageCanvas.width = img.width

    pageCanvas.height = pageCanvas.width * hgtWidRate

    # 缩放画布大小
    scaleRate = pageCanvas.width / img.width
    ctx.scale(scaleRate, scaleRate)

    #将图形绘入canvas
    ctx.drawImage(img, 0, 0)

    # 已绘制
    $scope.isCurrentPageDrawed = true

  #私有函数
  init = ()->
    $scope.meetingId = $stateParams.meetingId
    $scope.currentPageId = 1 #默认显示第一页
    $scope.maxPageId = 1
    $scope.isCurrentPageDrawed = false # 当前页码未绘图
    $scope.refreshMeetingData($scope.meetingId)
    initSubscribe($scope.meetingId)

  #公有函数

  #监听窗口大小变化
  $(window).on('resize', (e)->
    console.log($scope.currentPageId)
    drawPageImage($scope.currentPageId)
  )

  #监听会议数据加载完成消息
  $scope.$on 'meeting_data_loaded', ()->
    $scope.maxPageId = $scope.meeting.ppt.pageCount
    # 开始监听图片加载完成消息
    $scope.readyPageImagesId = []
    $scope.$on 'page_image_loaded', (event, pageId)->
      $scope.readyPageImagesId.push(pageId)

      # 加载完成的页码与当前页码匹配 且未绘制
      if pageId == $scope.currentPageId and !$scope.isCurrentPageDrawed
        drawPageImage(pageId)

  #刷新数据
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
#        for i in [1..$scope.meeting.ppt.pageCount]
#          do (i)->
#            $scope.pageRange.push(i)

        # 广播会议数据加载完成消息
        $rootScope.$broadcast('meeting_data_loaded')
    ,
      #onError
      (httpResponse)->
        console.log(httpResponse)
    )

  $scope.$on 'updatePageId', (a, pageId)->
    $scope.currentPageId = pageId
    drawPageImage(pageId)
    $scope.$apply()

  #订阅会议实时消息
  initSubscribe = (meetingId)->
    io.socket.on 'meeting', (obj)->
      if obj.verb is 'messaged'
        console.log(obj)
        pageId=parseInt(obj.data.pageId)
        $rootScope.$broadcast('updatePageId', pageId)

    #订阅
    io.socket.get('/meeting/subscribeWatch', {meetingId: meetingId})

    return true

  #初始化
  init()
