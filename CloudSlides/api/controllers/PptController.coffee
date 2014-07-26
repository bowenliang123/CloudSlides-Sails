module.exports =



  upload: (req, res)->
    #取出
    userId = req.param('userId');
    size = req.param('size');
    type = req.param('type');
    fileName = req.param('fileName');

    pptFile = req.file('file');


    #上传
    pptFile.upload (err, files)->
      if err
          return res.serverError(err);

      #增加一条PPT记录
      Ppt.create({
        owner: userId
        fileName: fileName
        pageCount: 0 # 默认为未转换，因此页数为0
        size: size
        type: type
      }).exec (err, newppt)->
        sails.log(newppt);
        User.findOne({id:userId}).populate('ppts').exec (err, user)->
          sails.log(user);
#          user.ppts.add(newppt.id);
#          user.save();

      return res.json {
        message: files.length + ' file(s) uploaded successfully!'
        files: files
      }

