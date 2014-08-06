angular.module 'attendmeetingCtrl', ['User', 'Meeting']
.controller 'attendmeetingCtrl', ($scope, User, Meeting)->

  # 初始化函数
  init = ()->
    $scope.refreshMeetingData()


  #公有函数

  #刷新我参加的会议数据
  $scope.refreshMeetingData = ()->
    $scope.attendMeetings = []
    console.log('refreshMeetingData')
    Meeting.queryAttend(
      userId: User.getUserId()
    ,
      #onSucess
      (value, responseHeaders)->
        $scope.attendMeetings = value

    ,
      #onError
      (httpResponse)->
    )


  #显示加入会议对话框
  $scope.showModalAttendMeeting = ()->
    console.log('showModalAttendMeeting')
    #显示加入会议modal
    $('#attendNewMeetingModal').modal('show')
    return null

  #加入会议
  $scope.attendNewMeeting = ()->
    console.log('attendNewMeeting')
    Meeting.attend(
      userId: User.getUserId()
      meetingId: $scope.attendNewMeetingId
    ,
      #onSucess
      (value, responseHeaders)->
        #加入成功
        if value.status == 0
          $('#attendNewMeetingModal').modal('hide')
          $scope.refreshMeetingData()
    ,
      #onError
      (httpResponse)->
    )

  #退出会议
  $scope.quitAttendMeeting = (meetingId)->
    Meeting.quit(
      userId: User.getUserId()
      meetingId: meetingId
    ,
      #onSucess
      (value, responseHeaders)->
        $scope.refreshMeetingData()
    ,
      #onError
      (httpResponse)->
    )

  #初始化
  init()

