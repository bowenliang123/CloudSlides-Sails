// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('welcomeCtrl', ['User']).controller('welcomeCtrl', function($scope, User) {
    return $scope.login = function() {
      var a, email, password;
      email = $scope.loginEmail;
      password = $scope.loginPassword;
      console.log(email + ' ' + password);
      a = User.login({
        email: email,
        password: password
      });
      return console.log(a);
    };
  });

}).call(this);

//# sourceMappingURL=welcomeCtrl.map
