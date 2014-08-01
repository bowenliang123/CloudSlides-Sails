angular.module 'welcome.loginModalCtrl', ['User']
.controller 'welcome.loginModalCtrl', ($scope, $rootScope, $location, User)->
  #变量声明

  #私有

  #公共
  #登录
  $scope.login = ()->
    email = $scope.loginEmail;
    password = $scope.loginPassword;

    #执行登录操作
    User.login(
      email: email
      password: password
    ,
      #onSucess
      (value, responseHeaders)->
        status = value.status;
        data = value.data;

        if status == 101
          #电邮及密码配对不正确
          alert('电邮及密码配对不正确')
          return

        else if status == 0
          # 登录成功
          # 写入登录信息
          User.setLoginInfo(data.user, data.token);
          # 隐藏登录框
          $('#loginModal').modal('hide');

          $rootScope.$broadcast 'login_success';

          # 跳转到myppt页面
          $location.url('/myppt');

    ,
      #onError
      (httpResponse)->
        console.log(httpResponse);
    )
