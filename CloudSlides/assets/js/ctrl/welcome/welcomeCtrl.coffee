angular.module 'welcomeCtrl', ['User']
.controller 'welcomeCtrl', ($scope, $window,User)->
  #变量声明
  $scope.isLogined = User.isLogined()
  #私有
  #公共



