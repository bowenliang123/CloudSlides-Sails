/**
 * UserController
 *
 * @description :: Server-side logic for managing users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

    /**
     * 用户登录接口
     * @param req
     * @param res
     */
    login: function (req, res) {
        //params
        var email = req.param('email');
        var password = req.param('password');


        User.findOne({email: email, password: password})
            .exec(function findCB(err, user) {
                var result = {};

                //error handling
                if (err) {
                    console.log(err);
                    res.status(500);
                    return res.send(err);
                }
                console.log(user);

                if (!user) {
                    result={
                        status: 101,
                        data: 'user not found'
                    }
                    return res.ok(result);
                }



                result = {
                    status: 0,
                    data: {
                        //用户信息
                        user: user,
                        //临时token
                        token: '1234567890'
                    }
                }
                //返回token
                return res.json(result);
            })
    },


    /**
     * 用户注册接口
     * @param req
     * @param res
     */
    signup: function (req, res) {
        //params
        var email = req.param('email');
        var password = req.param('password');

        User.findOne({email: email})
            .exec(function (err, user) {
                //相同Email已注册
                if (user) {
                    return res.json({
                        status: 101
                    });
                }


                //新增user
                var newUser = {email: email, password: password}
                console.log(newUser);
                User.create(newUser, function () {
                    return res.json({
                        status: 0,
                        token: '1234567890'
                    });
                });
            });
    }


};

