angular.module 'watchCtrl', ['User', 'Meeting']
.controller 'watchCtrl', ($scope, $stateParams, User, Meeting)->
  #私有函数
  init = ()->
    $scope.meetingId = $stateParams.meetingId;
    $scope.refreshMeetingData($scope.meetingId);

  #公有函数

  #刷新数据
  $scope.refreshMeetingData = (meetingId)->
    console.log('refreshMeetingData');
    $scope.meeting = {};
    Meeting.get(
      id: $scope.meetingId
    ,
      #onSuccess
      (value, responseHeaders)->
        $scope.meeting = value;
    ,
      #onError
      (httpResponse)->
        console.log(httpResponse);
    )

  #初始化
  init();
