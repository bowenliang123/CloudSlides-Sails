angular.module 'User', ['LocalStorageModule']
.factory 'User', ($resource, localStorageService)->
  key_loginInfo = 'loginInfo';

  obj = $resource '/user/:id', null, {
    'update': { method: 'PUT' },
    'login':
      url: '/user/login',
      method: 'POST',
    'signup':
      url: '/user/signup',
      method: 'POST'

  }

  #检测是否已登录
  obj.isLogined = ()->
    loginInfo = obj.getLoginInfo()
    return if loginInfo then true else false


  # 读取用户个人信息
  obj.getUserInfo = ()->
    loginInfo = obj.getLoginInfo();
    return loginInfo.user;

  # 写入用户个人信息
  obj.setUserInfo = (user)->
    loginInfo = this.getLoginInfo();
    obj.setLoginInfo(user, loginInfo.token);
    return;

  #  读取登录信息
  obj.getLoginInfo = ()->
    return localStorageService.get(key_loginInfo);

  # 写入登录信息
  obj.setLoginInfo = (user, token)->
    loginInfo =
      user: user
      token: token;

    localStorageService.set(key_loginInfo, loginInfo);

  return obj;