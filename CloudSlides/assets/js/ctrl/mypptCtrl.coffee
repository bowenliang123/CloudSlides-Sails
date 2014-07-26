angular.module 'mypptCtrl', ['User', 'Ppt', 'angularFileUpload']
.controller 'mypptCtrl', ($scope, $upload, User, Ppt)->



  $scope.onFileSelect = ($files) ->
    # 准备上传
    pptFile = $files[0];

    # 开始上传
    $scope.isUploading = true;
    $scope.upload = $upload.upload({
      url: '/ppt/upload',
      method: 'POST',
      headers: User.genAuthHeader(),
    #withCredentials: true,
      data: {
        userId: User.getUserId()
        size: pptFile.size
        type: pptFile.type
        fileName: pptFile.name
      },
      file: pptFile, #or list of files ($files) for html5 only
    #fileName: 'doc.jpg' or ['1.jpg', '2.jpg', ...] // to modify the name of the file(s)
    # customize file formData name ('Content-Desposition'), server side file variable name.
    #fileFormDataName: myFile, //or a list of names for multiple files (html5). Default is 'file'
    #customize how data is added to formData. See #40#issuecomment-28612000 for sample code
    #formDataAppender: function(formData, key, val){}
    }).progress((evt)->
      percent = parseInt(100.0 * evt.loaded / evt.total);
      console.log('percent: ' + percent);
      $scope.progress = percent;
    ).success((data, status, headers, config) ->
      # file is uploaded successfully
      console.log(data);
      $scope.isUploading = false;
    );

  #私有方法


  ##共有方法

  #刷新数据
  $scope.refreshPptsData = ()->
    Ppt.query({
        owner: User.getUserId()
      },

      #onSucess
      (value, responseHeaders)->
        console.log(value);
        $scope.ppts = value;
    ,
      #onError
      (httpResponse)->
    );

  #删除幻灯
  $scope.deletePpt = (pptId)->



  #初始化
  init = ()->
    $scope.isUploading = false;
    $scope.ppts=[];
    $scope.progress = 0;
    $scope.refreshPptsData();

  # 初始化
  init();