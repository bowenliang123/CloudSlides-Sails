angular.module 'controlCtrl', ['User', 'Meeting']
.controller 'controlCtrl', ($scope, $stateParams, $timeout, $rootScope, User, Meeting)->
  #私有变量


  $scope.currentPageId = 1

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
    $scope.meetingId = $stateParams.meetingId #会议ID
    $scope.currentPageId = 1 #默认显示第一页
    $scope.maxPageId = 1;
    $scope.isCurrentPageDrawed = false # 当前页码未绘图
    $scope.refreshMeetingData($scope.meetingId) #更新会议数据

  #公有函数

  #监听窗口大小变化
  $(window).on('resize', (e)->
    console.log($scope.currentPageId)
    drawPageImage($scope.currentPageId)
  )


  #监听会议数据加载完成消息
  $scope.$on 'meeting_data_loaded', ()->
    $scope.maxPageId = $scope.meeting.ppt.pageCount;
    # 开始监听图片加载完成消息
    $scope.readyPageImagesId = []
    $scope.$on 'page_image_loaded', (event, pageId)->
      $scope.readyPageImagesId.push(pageId)

      # 加载完成的页码与当前页码匹配 且未绘制
      if pageId == $scope.currentPageId and !$scope.isCurrentPageDrawed
        drawPageImage(pageId)

    return

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
        $scope.pageRange = [1..$scope.meeting.ppt.pageCount];

        # 广播会议数据加载完成消息
        $rootScope.$broadcast('meeting_data_loaded')
    ,
      #onError
      (httpResponse)->
        console.log(httpResponse)
    )

  $scope.updatePageId = (pageId)->
    $scope.currentPageId = pageId
    if pageId < 1 or pageId > $scope.maxPageId
      return
    else
      $scope.currentPageId = pageId;


      #发送页码更新请求
      io.socket.post('/meeting/updatePage',
        meetingId: $scope.meetingId
        pageId: pageId
      )

      # 未绘制
      $scope.isCurrentPageDrawed = false

      #如果页码在已加载的页面图像ID中，则绘制图片
      if pageId in $scope.readyPageImagesId
        drawPageImage(pageId)


  #初始化
  init()


  return null

  