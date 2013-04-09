require('lib/setup')

Spine = require('spine')
Main = require 'controllers/main'

class App extends Spine.Controller
  constructor: ->
    super
    
    params = @getURLParams()
    
    if params.workerId and @workerExists(params)
      @html "<p>Sorry!  You are not eligible for our behavior experiment becuase you have played this game before.  Please do not accept this HIT or return it. </p>"
    else 
      @main = new Main
      @main.parseParams(params)
      @append @main
      @main.render()
    
  workerExists: (params) ->
    toSend = {'workerId': params.workerId}
    $.ajax({
      type: 'POST'
      async: false
      url: 'checkworker.php'
      data: toSend
      dataType: 'text'
      success: (data) ->
        return data.found;
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        console.log(textStatus)
      })
    return false
    
  unescapeURL: (s) ->
    decodeURIComponent s.replace(/\+/g, "%20")
    
  getURLParams: ->
    params = {}
    m = window.location.href.match(/[\\?&]([^=]+)=([^&#]*)/g)
    if m
      i = 0
      while i < m.length
        a = m[i].match(/.([^=]+)=(.*)/)
        params[@unescapeURL(a[1])] = @unescapeURL(a[2])
        i++
    return params

module.exports = App
    