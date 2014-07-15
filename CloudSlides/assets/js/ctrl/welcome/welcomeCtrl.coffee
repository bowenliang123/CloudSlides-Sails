angular.module 'welcomeCtrl', ['User']
.controller 'welcomeCtrl', ($scope, User)->
  #变量声明
  #私有
  #公共
  $scope.login = ()->
#    console.log($scope.loginEmail);
    email= $scope.loginEmail;
    password = $scope.loginPassword;
    console.log(email+' '+password)
    a = User.login {email:email, password:password};
    console.log(a)




