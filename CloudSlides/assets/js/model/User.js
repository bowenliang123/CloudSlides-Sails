// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('User', ['LocalStorageModule']).factory('User', function($resource, localStorageService) {
    var key_loginInfo, obj;
    key_loginInfo = 'loginInfo';
    obj = $resource('/user/:id', null, {
      'update': {
        method: 'PUT'
      },
      'login': {
        url: '/user/login',
        method: 'POST'
      },
      'signup': {
        url: '/user/signup',
        method: 'POST'
      }
    });
    obj.isLogined = function() {
      var loginInfo;
      loginInfo = obj.getLoginInfo();
      if (loginInfo && loginInfo.user !== void 0) {
        return true;
      } else {
        return false;
      }
    };
    obj.getUserInfo = function() {
      var loginInfo;
      loginInfo = obj.getLoginInfo();
      return loginInfo.user;
    };
    obj.setUserInfo = function(user) {
      var loginInfo;
      loginInfo = this.getLoginInfo();
      obj.setLoginInfo(user, loginInfo.token);
    };
    obj.getLoginInfo = function() {
      return localStorageService.get(key_loginInfo);
    };
    obj.setLoginInfo = function(user, token) {
      var loginInfo;
      loginInfo = {
        user: user,
        token: token
      };
      return localStorageService.set(key_loginInfo, loginInfo);
    };
    obj.clearLoginInfo = function() {
      return localStorageService.remove(key_loginInfo);
    };
    return obj;
  });

}).call(this);

//# sourceMappingURL=User.map
