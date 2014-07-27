// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('attendmeetingCtrl', ['User', 'Meeting']).controller('attendmeetingCtrl', function($scope, User, Meeting) {
    var init;
    init = function() {
      return $scope.refreshMeetingData();
    };
    $scope.refreshMeetingData = function() {
      $scope.attendMeetings = [];
      console.log('refreshMeetingData');
      return Meeting.queryAttend({
        userId: User.getUserId()
      }, function(value, responseHeaders) {
        return $scope.attendMeetings = value;
      }, function(httpResponse) {});
    };
    $scope.showModalAttendMeeting = function() {
      console.log('showModalAttendMeeting');
      $('#attendNewMeetingModal').modal('show');
      return null;
    };
    $scope.attendNewMeeting = function() {
      console.log('attendNewMeeting');
      return Meeting.attend({
        userId: User.getUserId(),
        meetingId: $scope.attendNewMeetingId
      }, function(value, responseHeaders) {
        if (value.status === 0) {
          $('#attendNewMeetingModal').modal('hide');
          $scope.refreshMeetingData();
        }
      }, function(httpResponse) {});
    };
    return init();
  });

}).call(this);

//# sourceMappingURL=attendmeetingCtrl.map
