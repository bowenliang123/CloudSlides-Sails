// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('controlCtrl', ['User', 'Meeting']).controller('controlCtrl', function($scope, $stateParams, User, Meeting) {
    var init;
    init = function() {
      $scope.meetingId = $stateParams.meetingId;
      return $scope.refreshMeetingData($scope.meetingId);
    };
    $scope.refreshMeetingData = function(meetingId) {
      console.log('refreshMeetingData');
      $scope.meeting = {};
      return Meeting.get({
        id: $scope.meetingId
      }, function(value, responseHeaders) {
        return $scope.meeting = value;
      }, function(httpResponse) {
        return console.log(httpResponse);
      });
    };
    return init();
  });

}).call(this);

//# sourceMappingURL=controlCtrl.map
