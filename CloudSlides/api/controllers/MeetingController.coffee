module.exports =
  create: (req,res)->
    #取出变量
    pptId = req.param('pptId');
    holderId = req.param('holderId');
    topic = req.param('topic');

    #新增会议记录
    Meeting.create({
      holder: holderId
      ppt: pptId
      topic: topic
    }).exec (err, newMeeting)->
      if err
        return res.ok(err);

      return res.json({
        status:0
      });


  delete:(req,res)->
    #取出变量
    meetingId = req.param('meetingId');

    #删除对应会议记录
    Meeting.destroy({id:meetingId}).exec (err)->
      if err
        sails.log(err);
        return res.serverError(err);
      return res.json({
        status: 0
      });
