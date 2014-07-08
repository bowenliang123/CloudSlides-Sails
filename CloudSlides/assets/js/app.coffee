angular.module 'cs', [
  'ui.router'
]
.config ($stateProvider, $urlRouterProvider)->
  $stateProvider
  .state 'welcome', {
    url: '/welcome'
    templateUrl: 'views/welcome.html'
  }


  $urlRouterProvider.otherwise('/welcome')
