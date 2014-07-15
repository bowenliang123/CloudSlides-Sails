angular.module 'welcome.loginModalCtrl', ['User']
.controller 'welcome.loginModalCtrl', ($scope, User, $location)->
  #变量声明

  #私有

  #公共
  #登录
  $scope.login = ()->
    email = $scope.loginEmail;
    password = $scope.loginPassword;
    console.log($scope.loginEmail)
    console.log(password)

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
          #相同email已注册
          alert('相同email已注册')
          return

        else if status == 0
          #登录成功
          User.setLoginInfo(data.user, data.token);
          alert('登录成功')
          $location.url('/myppt');

    ,
      #onError
      (httpResponse)->
        console.log(httpResponse);
    )
