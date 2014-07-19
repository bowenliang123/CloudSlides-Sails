angular.module 'navbarCtrl', ['User']
.controller 'navbarCtrl', ($scope, $rootScope, User)->
  init = ()->
    $scope.isLogined = User.isLogined();
    $scope.userLoginInfo = if $scope.isLogined then User.getLoginInfo() else undefined;
    console.log('init')

  $scope.logout = ()->
    User.clearLoginInfo();
    $rootScope.$broadcast 'logout_success';
    window.location = '/'

  $scope.$on 'login_success', ()->
    $scope.isLogined = true;
    $scope.userLoginInfo = if $scope.isLogined then User.getLoginInfo() else undefined;

  $scope.$on 'logout_success', ()->
    $scope.isLogined = false;
    $scope.userLoginInfo = if $scope.isLogined then User.getLoginInfo() else undefined;

  # 初始化
  init();