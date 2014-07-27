// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('Meeting', ['User']).factory('Meeting', function($resource, User) {
    var obj;
    obj = $resource('/meeting/:id', {}, {
      'create': {
        url: '/meeting/create',
        method: 'POST'
      },
      'delete': {
        url: '/meeting/delete',
        method: 'POST'
      }
    });
    return obj;
  });

}).call(this);

//# sourceMappingURL=Meeting.map
