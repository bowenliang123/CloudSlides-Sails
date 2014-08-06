angular.module 'UAService', []
.factory 'UAService', ()->
  #私有函数
  userAgent = navigator.userAgent.toLowerCase()

  getAndroidVersion = ()->
    index = userAgent.indexOf("android")
    if (index >= 0)
      androidVersion = parseFloat(userAgent.slice(index + 8))
      console.log(androidVersion)
      return androidVersion
    else
      return -1

  isTargetBrowser = (browserKeyword)->
    return if userAgent.indexOf(browserKeyword) >= 0 then true else false

  isUcBrowser = ()->
    return isTargetBrowser('ucweb')

  isQqBrowser = ()->
    return isTargetBrowser('mqqbrowser')

  isChrome = ()->
    return isTargetBrowser('chrome')

  isMiuiBrowser = ()->
    return isTargetBrowser('miuibrowser')


  obj = {}
  obj.isDownGraded = ()->
    if isUcBrowser() or isQqBrowser() or isChrome()
      return false
    else if isMiuiBrowser()
      return true

    return true

  obj.androidVersion = getAndroidVersion()
  obj.isAndroid = if getAndroidVersion() > 0 then true else false

  return obj