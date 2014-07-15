angular.module 'welcome.signupModalCtrl', ['User']
.controller 'welcome.signupModalCtrl', ($scope, User)->
  #变量声明
  #私有
  #公共
  $scope.signup = ()->
    email = $scope.signupEmail;
    password = $scope.signupPassword;
    passwordConfirm = $scope.signupPasswordConfirm;


    #    验证密码和密码二次输入是否一致
    if (password != passwordConfirm)
      alert('输入一致的密码！');
      return;

    #注册新用户
    User.signup(
        email: email
        password: password
      ,
      #onSucess
      (value, responseHeaders)->
        status = value.status;

        if (status == 0)
          User.setLoginInfo(email, token: value.token);
        else if (status == 101)
          console.log('same email user existed');

    ,
      #onError
      (httpResponse)->
        console.log(httpResponse);
    )
