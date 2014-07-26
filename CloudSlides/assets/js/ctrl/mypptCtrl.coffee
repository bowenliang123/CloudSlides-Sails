angular.module 'mypptCtrl', ['User', 'Ppt', 'angularFileUpload']
.controller 'mypptCtrl', ($scope, $upload, User, Ppt)->
#  newppt = new Ppt({
#    filename: 'test.ppt'
#    pageCount: 5
#    owner: User.getUserId()
#  })
#
#  newppt.$save();
  $scope.ppts = Ppt.query(
    #onSucess
    (value, responseHeaders)->
  ,
    #onError
    (httpResponse)->
  );


  #  $scope.onFileSelect = ($files)->
  #    for i in [0.. $files.length - 1]
  #      file = $files[i];


  $scope.progress = 0;

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


  init = ()->
    $scope.isUploading = false;
  #    $scope.isUploading=true;

  # 初始化
  init();