/**
 * Meeting.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {

    connection: 'someMongodbServer',

    attributes: {
        //主题
        topic: 'string',

        //发起人
        holder: {
            model: 'User'
        },

        //参与人
        attendees: {
            collection: 'User',
            via: 'attendMeetings'
        }
    }
};

