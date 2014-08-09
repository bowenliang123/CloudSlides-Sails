angular.module 'cs', [
  # angular componet
  'angularFileUpload'
  'LocalStorageModule'
  'ngResource'
  'ngMessages'
  'ui.router'
  'pascalprecht.translate'

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

  # services
  'UAService'

  # directives
  'drawing'
  'onloadnotify'

  # models
  'User'
  'Ppt'
  'Meeting'
]

# config angular-translate
.config ($translateProvider)->
  $translateProvider.useStaticFilesLoader(
    prefix: 'i18n/locale-'
    suffix: '.json'
  )
  #  $translateProvider.preferredLanguage('en')
  $translateProvider.determinePreferredLanguage()

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



