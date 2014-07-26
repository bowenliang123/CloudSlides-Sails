/**
 * User.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {

    connection: 'someMongodbServer',

    attributes: {
        //用户名
        name: 'string',

        //电邮
        email: 'string',

        //密码
        password: 'string',

        //幻灯
        ppts: {
            collection: 'Ppt',
            via: 'owner'
        },

        // 发起的会议
        holdMeetings: {
            collection: 'Meeting',
            via: 'holder'
        },

        //参与的会议
        attendMeetings: {
            collection: 'Meeting',
            via: 'attendees'
        }

    }

};

