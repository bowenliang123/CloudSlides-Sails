module.exports =

#新建会议
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






#删除会议
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

#查询用户观看的所有会议
  queryAttend: (req, res)->
    #取出变量
    userId = req.param('userId');

    #查询对应用户
    User.findOne({id: userId}).populate('attendMeetings').exec (err, user)->
      if err
        return res.serverError(err);

      #提取所有参加会议的ID
      meetingIds = [];
      for meeting in user.attendMeetings
        do (meeting)->
          meetingIds.push(meeting.id);

      #获取所有参加会议的详细信息
      Meeting.find({id: meetingIds})
      .populate('holder')
      .exec (err, meetingsFull)->
        if err
          return res.serverError(err);

        return res.json(meetingsFull);

#加入观看会议
  attend: (req, res)->
    #取出变量
    userId = req.param('userId');
    meetingId = req.param('meetingId');

    User.findOne({id: userId}).exec (err, user)->
      if err
        return res.serverError(err);

      sails.log('attend meeting');
      sails.log(user);
      Meeting.findOne({id: meetingId}).exec (err, meeting)->
        if err
          return res.serverError(err);

        user.attendMeetings.add(meetingId);
        user.save(sails.log);
        return res.json(
          status: 0
        );

#退出观看会议
  quit: (req, res)->
    #取出变量
    userId = req.param('userId');
    meetingId = req.param('meetingId');

    Meeting.findOne({id: meetingId}).exec (err, meeting)->
      if err
        return res.serverError(err);

      meeting.attendees.remove(userId);
      meeting.save();

      return res.ok();

#订阅观看的会议
  subscribeWatch: (req, res, next)->

    #取出变量
    meetingId = req.param('meetingId');

    sails.log('subscribeWatch ' + meetingId);

    #    Meeting.findOne({id: meetingId}).exec (err, meeting)->
    #      if err
    #        return res.serverError(err);

    #订阅指定会议
    Meeting.subscribe(req, meetingId, ['message']);

    return next();

#控制页码
  updatePage: (req, res)->
    #取出变量
    meetingId = req.param('meetingId');
    pageId = req.param('pageId');

    sails.log('updatePage ' + meetingId + ' ' + pageId);

    Meeting.message(meetingId, {pageId: pageId});

    return res.ok(
      meetingId: meetingId
      pageId: pageId
    );