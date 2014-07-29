angular.module 'cs', [
  'angularFileUpload'
  'ui.router'
  'ngResource'
  'ngMessages'
  'LocalStorageModule'

  # controllers
  'navbarCtrl'
  'welcomeCtrl'
  'welcome.loginModalCtrl'
  'welcome.signupModalCtrl'
  'mypptCtrl'
  'holdmeetingCtrl'
  'attendmeetingCtrl'
  'controlCtrl'
  'watchCtrl'

  # directives
  'drawing'
  'onloadnotify'

  # models
  'User'
  'Ppt'
  'Meeting'
]

#  ui states config
.config ($stateProvider)->
  $stateProvider

  # main
  .state 'main',
    url: '/main'
#    abstract:true
    templateUrl: 'views/main.html'


  #Welcome
  .state 'welcome',
    url: '/welcome'
    abstract: true
    templateUrl: 'views/welcome.html'

  .state 'welcome.index',
    url: '/index'
    views:
      'loginModal':
        templateUrl: 'views/welcome/loginModal.html'
      'signupModal':
        templateUrl: 'views/welcome/signupModal.html'


  #myppt
  .state 'myppt',
    url: '/myppt'
    templateUrl: 'views/myppt.html'

  #holdmeeting
  .state 'holdmeeting',
    url: '/holdmeeting'
    templateUrl: 'views/holdmeeting.html'

  #attendmeeting
  .state 'attendmeeting',
    url: '/attendmeeting'
    templateUrl: 'views/attendmeeting.html'


  #watch meeting
  .state 'watch',
    url: '/watch/:meetingId'
    templateUrl: 'views/watch.html'

  #control meeting
  .state 'control',
    url: '/control/:meetingId'
    templateUrl: 'views/control.html'


#ui route config
.config ($urlRouterProvider)->
  $urlRouterProvider.when('', '/welcome/index');



