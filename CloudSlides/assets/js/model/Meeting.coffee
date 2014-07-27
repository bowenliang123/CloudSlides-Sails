angular.module 'Meeting', ['User']
.factory 'Meeting', ($resource, User)->
  obj = $resource '/meeting/:id', {
  # paramDefaults
  }, {
  # actions
    'create':
      url: '/meeting/create'
      method: 'POST'
    'delete':
      url: '/meeting/delete'
      method: 'POST'
    'queryAttend':
      url: '/meeting/queryAttend'
      method: 'POST'
      isArray: true
    'attend':
      url: '/meeting/attend'
      method: 'POST'
  };

  return obj;