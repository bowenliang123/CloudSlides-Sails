angular.module 'cs', [
  'ui.router'
]

#  ui states config
.config ($stateProvider)->
  $stateProvider
  .state 'welcome', {
    url: '/welcome'
#    abstract: true
    templateUrl: 'views/welcome.html'
  }
  .state 'welcome.index',{
    url: '/index'
    views:
      'loginModal':
        templateUrl: 'views/welcome/loginModal.html'
      'signupModal':
        templateUrl: 'views/welcome/signupModal.html'
  }


#ui route config
.config ($urlRouterProvider)->
  $urlRouterProvider.when('', '/welcome/index');
