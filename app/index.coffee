require('lib/setup')

Spine = require('spine')
Main = require 'controllers/main'

class App extends Spine.Controller
  constructor: ->
    super
    
    params = @getURLParams()

    if params.workerId and @workerExists(params) is true
      @html "<h3>Sorry!  You are not eligible for our behavior experiment because you have played this game before based on our records.  Please return this HIT. </h3>"
    else 
      @main = new Main
      @main.parseParams(params)
      @append @main
      @main.render()
    
  workerExists: (params) =>
    toSend = {'workerId': params.workerId}
    obj = $.ajax({
      type: 'POST'
      async: false
      url: 'checkworker.php'
      data: toSend
      dataType: 'text'
      success: (data) =>
        start = data.indexOf("{") 
        end = data.indexOf("}") + 1
        data = data.substring(start, end)
        jsonObj = $.parseJSON(data)
        return jsonObj.found
      error: (XMLHttpRequest, textStatus, errorThrown) =>
        return false
      })
    text = obj.responseText
    start = text.indexOf("{")
    end = text.indexOf("}") + 1
    text = text.substring(start, end)
    jsonObj = $.parseJSON(text)
    return jsonObj.found    

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
    