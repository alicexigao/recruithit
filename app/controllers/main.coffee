Spine = require('spine')

class Main extends Spine.Controller
  className: "main"
  
  elements:
    "input#idSubmitButton" : "submitButton"
    "input:checkbox" : "checkbox"
    "input#assignment_id" : "inputAssignId"
  
  events:
    "change input:checkbox" : "checkboxChanged"
    
  constructor: ->
    super
    @submitButtonDisplayed = false
    
  render: ->
    @html require('views/main')(@)
    
    if @mode isnt "accepted" or @submitButtonDisplayed is false
      @submitButton.hide()

    @inputAssignId.val(@params.assignmentId)
    
  parseParams: (params) ->
    @params = params
    if not params.assignmentId
      @mode = "preview"
    else if params.assignmentId is "ASSIGNMENT_ID_NOT_AVAILABLE"
      @mode = "preview"
    else
      @mode = "accepted"
    
    if params.turkSubmitTo is undefined
      @submitTo = ""
    else 
      @submitTo = params.turkSubmitTo + "/mturk/externalSubmit"
      
    @method = 'POST'

  validate: =>
    if not @checkbox.is(':checked')
      return false
    return true

  checkboxChanged: (ev) =>
    ev.preventDefault()
    if @mode isnt "accepted"
      return
    if @validate() is true
      @submitButtonDisplayed = true
      @submitButton.show()
    else 
      @submitButtonDisplayed = false
      @submitButton.hide()
    
    
module.exports = Main