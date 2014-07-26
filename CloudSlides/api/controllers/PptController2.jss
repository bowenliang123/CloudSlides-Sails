/**
 * PptController
 *
 * @description :: Server-side logic for managing Ppts
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

    /**
     * 上传新的PPT
     * @param req
     * @param res
     */
    upload: function  (req, res) {
        //取出
        var userId = req.param('userId');
        var metaData = req.param('metaData');
        var pptFile = req.file('file');

        //上传
        pptFile.upload(function (err, files) {
            if (err)
                return res.serverError(err);

            return res.json({
                message: files.length + ' file(s) uploaded successfully!',
                files: files
            });
        });
    }
	
};

