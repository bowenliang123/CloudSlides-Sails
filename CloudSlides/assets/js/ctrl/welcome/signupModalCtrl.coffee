angular.module 'welcome.signupModalCtrl', ['User']
.controller 'welcome.signupModalCtrl', ($scope, $location, User)->
  #变量声明
  #私有
  #公共
  $scope.signup = ()->
    email = $scope.signupEmail;
    password = $scope.signupPassword;
    passwordConfirm = $scope.signupPasswordConfirm;
    name = $scope.signupName;


    #    验证密码和密码二次输入是否一致
    if (password != passwordConfirm)
      alert('输入一致的密码！');
      return;

    #注册新用户
    User.signup(
      email: email
      password: password
      name: name
    ,
      #onSucess
      (value, responseHeaders)->
        status = value.status;

        if (status == 0)
          # 注册成功
          # 写入用户信息
          User.setLoginInfo(value.user, value.token);
          # 隐藏注册框
          $('#signupModal').modal('hide');
          # 跳转页面
          $location.url('/myppt');
          return;
        else if (status == 101)
          # 已有相同用户注册
          alert('相同电邮用户已注册');
          return;
    ,
      #onError
      (httpResponse)->
        console.log(httpResponse);
    )
