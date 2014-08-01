###
UserController

@description :: Server-side logic for managing users
@help        :: See http://links.sailsjs.org/docs/controllers
###
module.exports =

#用户登录接口
  login: (req, res)->
    #提取变量
    email = req.param 'email'
    password = req.param 'password'

    sails.log('login with email: ' + email + ' password:' + password)

    User.findOne
      email: email
      password: password
    .exec (err, user)->
      return res.serverError err if err

      if !user
        return res.json
          status: 101
          data: 'user not found'
      else
        return res.json
          status: 0
          data:
            user: user
            token: '1234567890'

#用户注册接口
  signup: (req, res)->
    #提取变量
    email = req.param("email")
    password = req.param("password")
    name = req.param("name")


    User.findOne(email: email).exec (err, user) ->
      #相同Email已注册
      return res.json(status: 101)  if user

      User.create
        email: email
        password: password
        name: name
      , (err, newuser)->
        return res.json
          status: 0
          user: newuser
