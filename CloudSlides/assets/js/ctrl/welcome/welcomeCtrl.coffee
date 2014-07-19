angular.module 'welcomeCtrl', ['User']
.controller 'welcomeCtrl', ($scope, $window,User)->
  #变量声明

  #私有
  #公共
#  init = ()->
#    $scope.isLogined = User.isLogined();
#    $scope.userLoginInfo = if $scope.isLogined then User.getLoginInfo() else undefined;
#
#  $scope.logout = ()->
#    User.clearLoginInfo();
#    $window.location.reload();
#
#  # 初始化
#  init();




