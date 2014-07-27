angular.module 'holdmeetingCtrl', ['User', 'Ppt', 'Meeting']
.controller 'holdmeetingCtrl', ($scope, $timeout, User, Ppt, Meeting)->
  #私有函数
  init = ()->
    #刷新会议数据
    $scope.refreshMeetingData();


  #公共函数
  $scope.holdNewMeeting = ()->
    pptId = $scope.pptId;
    topic = $scope.newMeetingTopic;
    console.log($scope.pptId + ' ' + $scope.newMeetingTopic);

    Meeting.create(
      holderId: User.getUserId()
      pptId: pptId
      topic: topic
    ,
      #onSucess
      (value, responseHeaders)->

        #会议增加成功
        if value.status == 0
          #刷新会议数据
          $scope.refreshMeetingData();
          #隐藏对话框
          $('#holdNewMeetingModal').modal('hide');


    ,
      #onError
      (httpResponse)->
        console.log(httpResponse);
    )

  $scope.deleteHoldMeeting = (meetingId)->
    Meeting.delete(
      meetingId: meetingId
    ,
      #onSuccess
      (value, responseHeaders)->
        console.log(value);
        if value.status == 0
          alert('删除成功');

          #刷新会议数据
          $scope.refreshMeetingData();
    ,
      #onError
      (httpResponse) ->
    )

  $scope.refreshMeetingData = ()->
    console.log('refreshMeetingData');
    #查询我发气的会议
    Meeting.query({
        holder: User.getUserId()
      },
      #onSucess
      (value, responseHeaders)->
#        console.log(value);
        $scope.holdMeetings = value;
    ,
      #onError
      (httpResponse)->
    );

  $scope.showModalHoldNewMeeting = ()->
    $('#holdNewMeetingModal').modal('show');

    #重新获取可用PPT数据
    $scope.ppts = [];
    Ppt.query({
        owner: User.getUserId()
      },

      #onSucess
      (value, responseHeaders)->
#        console.log(value);
        $scope.ppts = value;

      #延时对radio赋予样式
#        $timeout(()->
#          $(':radio').radio();
#        ,  50);
    ,
      #onError
      (httpResponse)->
    );


  #初始化
  $scope.holdMeetings = [];
  $scope.ppts = [];
  $scope.newMeetingPptId = '';
  init();

