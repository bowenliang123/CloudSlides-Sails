angular.module 'mypptCtrl', []
.controller 'mypptCtrl', ($scope, User)->
  User.query((users)->
    console.log(users)
  )


