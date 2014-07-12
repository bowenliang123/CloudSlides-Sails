angular.module 'User',[]
.factory 'User', ($resource)->
  return $resource '/user/:id', null,
    {
      'update': { method:'PUT' }
    }