// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('cs', ['ui.router']).config(function($stateProvider) {
    return $stateProvider.state('welcome', {
      url: '/welcome',
      templateUrl: 'views/welcome.html'
    }).state('welcome.index', {
      url: '/index',
      views: {
        'loginModal': {
          templateUrl: 'views/welcome/loginModal.html'
        },
        'signupModal': {
          templateUrl: 'views/welcome/signupModal.html'
        }
      }
    });
  }).config(function($urlRouterProvider) {
    return $urlRouterProvider.when('', '/welcome/index');
  });

}).call(this);

//# sourceMappingURL=app.map
