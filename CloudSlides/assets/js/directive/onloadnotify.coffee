angular.module 'onloadnotify', []
.directive "onloadnotify", ($rootScope)->
  restrict: "A"
  link: (scope, element, attrs) ->
    element.bind 'load', (event)->

      #注意从html获取属性名称需要全部小写，如此处pageid
      pageId = parseInt attrs.pageid  #先强制转换为数字

      #全局广播页面图像加载完成的消息
      $rootScope.$broadcast 'page_image_loaded', pageId

    return