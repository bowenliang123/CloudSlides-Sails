// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('cs', ['ui.router', 'ngResource', 'ngMessages', 'LocalStorageModule', 'welcomeCtrl', 'welcome.loginModalCtrl', 'welcome.signupModalCtrl', 'mypptCtrl', 'User']).config(function($stateProvider) {
    return $stateProvider.state('main', {
      url: '/main',
      templateUrl: 'views/main.html'
    }).state('welcome', {
      url: '/welcome',
      abstract: true,
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
    }).state('myppt', {
      url: '/myppt',
      templateUrl: 'views/myppt.html'
    });
  }).config(function($urlRouterProvider) {
    return $urlRouterProvider.when('', '/welcome/index');
  });

}).call(this);

//# sourceMappingURL=app.map
