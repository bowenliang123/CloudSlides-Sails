module.exports =
  create: (req, res)->
    #取出变量
    pptId = req.param('pptId');
    holderId = req.param('holderId');
    topic = req.param('topic');

    #新增会议记录
    Meeting.create(
      holder: holderId
      ppt: pptId
      topic: topic
    ).exec (err, newMeeting)->
      if err
        return res.ok(err);

      return res.json(
        status: 0
      );


  delete: (req, res)->
    #取出变量
    meetingId = req.param('meetingId');

    #删除对应会议记录
    Meeting.destroy({id: meetingId}).exec (err)->
      if err
        sails.log(err);
        return res.serverError(err);
      return res.json(
        status: 0
      );

  queryAttend: (req,res)->
    #取出变量
    userId= req.param('userId');

    #查询对应用户
    User.findOne({id:userId}).populate('attendMeetings').exec (err, user)->
      if err
        return res.serverError(err);

      sails.log('queryAttend');
      sails.log(user);
      return res.json(user.attendMeetings);

  attend: (req, res)->
    #取出变量
    userId= req.param('userId');
    meetingId = req.param('meetingId');

    User.findOne({id:userId}).exec (err, user)->
      if err
        return res.serverError(err);

      sails.log('attend meeting');
      sails.log(user);
      Meeting.findOne({id:meetingId}).exec (err, meeting)->
        if err
          return res.serverError(err);

#        meeting.attendees.add(userId);
#        meeting.save(sails.log);

        user.attendMeetings.add(meetingId);
        user.save(sails.log);



