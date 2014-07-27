angular.module 'Ppt', ['User']
.factory 'Ppt', ($resource, User)->
  # 初始化对象

  obj = $resource '/ppt/:id', {
    # paramDefaults
#    userId: User.getUserId()
#    token: User.getToken()
  }, {
    # actions
    'delete':{
      url: '/ppt/delete'
      method:'POST'
    }
  }

  return obj;