angular.module 'cs', [
  'ui.router',
  'ngResource',

  # controllers
  'welcomeCtrl',
  'mypptCtrl',


  # models
  'User'
]

#  ui states config
.config ($stateProvider)->
  $stateProvider

  #Welcome
  .state 'welcome', {
    url: '/welcome'
    abstract: true
    templateUrl: 'views/welcome.html'
  }
  .state 'welcome.index', {
    url: '/index'
    views:
      'loginModal':
        templateUrl: 'views/welcome/loginModal.html'
      'signupModal':
        templateUrl: 'views/welcome/signupModal.html'
  }

  #myppt
  .state 'myppt', {
    url: '/myppt'
    templateUrl: 'views/myppt.html'
  }

#ui route config
.config ($urlRouterProvider)->
  $urlRouterProvider.when('', '/welcome/index');
