// Generated by CoffeeScript 1.7.1
(function() {
  var base_file_path, fs, genImagePath, genPptFilePath, redisClient;

  fs = require('fs');

  base_file_path = '/cs/files/';

  redisClient = require("redis").createClient();

  genPptFilePath = function(pptId, fileName) {
    return base_file_path + pptId + '/' + fileName;
  };

  genImagePath = function(pptId, pageId) {
    return base_file_path + pptId + '/' + pageId + '.jpg';
  };

  module.exports = {
    "delete": function(req, res) {
      var pptId;
      pptId = req.param('pptId');
      return Ppt.destroy({
        id: pptId
      }).exec(function(err) {
        if (err) {
          sails.log(err);
          return res.serverError(err);
        }
        return res.json({
          status: 0
        });
      });
    },
    upload: function(req, res) {
      var fileName, pptFile, size, type, userId;
      userId = req.param('userId');
      size = req.param('size');
      type = req.param('type');
      fileName = req.param('fileName');
      pptFile = req.file('file');
      return Ppt.create({
        owner: userId,
        fileName: fileName,
        pageCount: 0,
        size: size,
        type: type
      }).exec(function(err, newppt) {
        var file_path;
        if (err) {
          return res.serverError(err);
        }
        sails.log(newppt);
        file_path = genPptFilePath(newppt.id, newppt.id);
        return pptFile.upload(file_path, function(err, files) {
          if (err) {
            return res.serverError(err);
          }
          redisClient.lpush('convert_ppt_ids', newppt.id);
          return res.json({
            status: 0,
            file: files
          });
        });
      });
    },
    getPptFile: function(req, res) {
      var pptId;
      pptId = req.param('pptId');
      return Ppt.findOne({
        id: pptId
      }).exec(function(err, ppt) {
        if (err) {
          return res.serverError(err);
        }
        if (!ppt) {
          return res.res.notFound();
        }
        return fs.readFile(genPptFilePath(pptId, pptId), function(err, data) {
          if (err) {
            sails.log('getImage error:');
            sails.log(err);
            if (err.code === 'ENOENT') {
              return res.notFound();
            }
          }
          res.set('Content-Type', ppt.type);
          return res.send(new Buffer(data));
        });
      });
    },
    getImage: function(req, res) {
      var pageId, pptId;
      pptId = req.param('pptId');
      pageId = req.param('pageId');
      return fs.readFile(genImagePath(pptId, pageId), function(err, data) {
        if (err) {
          sails.log('getImage error:');
          sails.log(err);
          if (err.code === 'ENOENT') {
            return res.notFound();
          }
          sails.log(err);
          return res.serverError(err);
        }
        res.set('Content-Type', 'image/jpeg');
        res.header('Last-Modified', new Date().getTime());
        return res.send(new Buffer(data));
      });
    },
    uploadImage: function(req, res) {
      var imageFile, image_file_path, pageId, pptId;
      pptId = req.param('pptId');
      pageId = req.param('pageId');
      imageFile = req.file('file');
      image_file_path = genImagePath(pptId, pageId);
      return imageFile.upload(image_file_path, function(err, files) {
        if (err) {
          return res.serverError(err);
        }
        return res.json({
          status: 0,
          file: files
        });
      });
    },
    updateConvertStatus: function(req, res) {
      var pageCount, pptId;
      pptId = req.param('pptId');
      pageCount = req.param('pageCount');
      return Ppt.update({
        id: pptId
      }, {
        pageCount: pageCount
      }).exec(function(err, updated) {
        if (err) {
          return res.serverError(err);
        }
        if (!pageCount) {
          return res.notFound();
        }
        return res.json({
          status: 0
        });
      });
    }
  };

}).call(this);

//# sourceMappingURL=PptController.map
