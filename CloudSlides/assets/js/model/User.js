// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('User', []).factory('User', function($resource) {
    return $resource('/user/:id', null, {
      'update': {
        method: 'PUT'
      }
    });
  });

}).call(this);

//# sourceMappingURL=User.map
