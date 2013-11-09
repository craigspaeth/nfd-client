ua = require 'ua-parser'

module.exports = (req, res, next) ->
  family = ua.parse(req.headers['user-agent'])?.family?.toLowerCase()
  if false and family in ['firefox', 'safari', 'chrome']
    res.locals.uaFamily = family
    next()
  else
    res.render 'user-agent/unsupported'