/**
 * Ppt.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {

    connection: 'someMongodbServer',

    attributes: {
        //拥有者
        owner: {
            model: 'User'
        },


        //幻灯文件名
        fileName: 'string',

        //页数，0为未转换，大于0为已转换页数
        pageCount: 'int',


        //文件大小
        size: 'int',

        //文件web类型
        type: 'string'


    }
};

