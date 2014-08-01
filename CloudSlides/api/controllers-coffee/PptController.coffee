fs = require('fs')

base_file_path = '/cs/files/'

redisClient = require("redis").createClient()

# 生成幻灯文件路径
genPptFilePath = (pptId, fileName)->
  return base_file_path + pptId + '/' + fileName

# 生成幻灯页图片文件路径
genImagePath = (pptId, pageId)->
  return base_file_path + pptId + '/' + pageId + '.jpg'

module.exports =

# 删除幻灯接口
  delete: (req, res)->
    #取出变量
    pptId = req.param('pptId')

    Ppt.destroy
      id: pptId
    .exec (err)->
      if err
        sails.log(err)
        return res.serverError(err)
      return res.json(
        status: 0
      )

#上传幻灯接口
  upload: (req, res)->
    #取出变量
    userId = req.param('userId')
    size = req.param('size')
    type = req.param('type')
    fileName = req.param('fileName')

    pptFile = req.file('file')


    #增加一条PPT记录
    Ppt.create
      owner: userId
      fileName: fileName
      pageCount: 0 # 默认为未转换，因此页数为0
      size: size
      type: type
    .exec (err, newppt)->
      if err
        return res.serverError(err)

      sails.log(newppt)

      #上传文件
      file_path = genPptFilePath(newppt.id, newppt.id)
      pptFile.upload file_path, (err, files)->
        if err
          return res.serverError(err)

        # 向Redis写入PPT转换任务
        redisClient.lpush 'convert_ppt_ids', newppt.id

        return res.json(
          status: 0
          file: files
        )


# 获取PPT文件
  getPptFile: (req, res)->
    #取出变量
    pptId = req.param('pptId');

    Ppt.findOne
      id: pptId
    .exec (err, ppt)->
      if err
        return res.serverError(err)

      if !ppt
        return res.res.notFound()

      # 获取文件
      fs.readFile genPptFilePath(pptId, pptId)
      , (err, data)->
        if err
          sails.log('getImage error:')
          sails.log(err)
          #文件不存在
          if err.code == 'ENOENT'
            return res.notFound()

        res.set('Content-Type', ppt.type)
        return res.send(new Buffer(data))


#获取图片接口
  getImage: (req, res)->
    #取出变量
    pptId = req.param('pptId')
    pageId = req.param('pageId')

    #    if_modified_since = req.header('If-Modified-Since')
    #    if if_modified_since < new Date().getTime()
    #      return res.status(304)

    fs.readFile(genImagePath(pptId, pageId),
    (err, data)->
      if err
        sails.log('getImage error:')
        sails.log(err)
        #文件不存在
        if err.code == 'ENOENT'
          return res.notFound()

        sails.log(err)
        return res.serverError(err)

      #获取文件成功，返回数据
      res.set('Content-Type', 'image/jpeg')
      res.header('Last-Modified', new Date().getTime())
      return res.send(new Buffer(data))
    )

#上传图片接口
  uploadImage: (req, res)->
    #取出变量
    pptId = req.param('pptId')
    pageId = req.param('pageId')

    imageFile = req.file('file')

    #上传文件
    image_file_path = genImagePath(pptId, pageId)
    imageFile.upload(image_file_path
    ,
    (err, files)->
      if err
        return res.serverError(err)

      return res.json(
        status: 0
        file: files
      )
    )


#更新转换状态
  updateConvertStatus: (req, res)->
    #取出变量
    pptId = req.param('pptId')
    pageCount = req.param('pageCount')

    sails.log('updateConvertStatus' + pptId + ' ' + pageCount);

    #更改页码数
    Ppt.update
      id: pptId
    ,
      pageCount: parseInt(pageCount)
    .exec (err, updated)->
      if err
        return res.serverError(err);

      if !pageCount
        return res.notFound();

      return res.json
        status: 0



