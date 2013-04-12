Spine = require('spine')

class Main extends Spine.Controller
  className: "main"
  
  elements:
    "input#idSubmitButton" : "submitButton"
    "input:checkbox" : "checkbox"
    "select#idFirstTime"  : "selectFirst"
    "select#idSecondTime" : "selectSecond"
    "input#assignment_id" : "inputAssignId"
  
  events:
    # "click input#idSubmitButton" : "submitButtonClicked"
    "change input:checkbox" : "checkboxChanged"
    "change select#idFirstTime" : "selectFirstChanged"
    "change select#idSecondTime" : "selectSecondChanged"
    
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
    if @selectFirst.val() is "default"
      return false
    if @selectSecond.val() is "default"
      return false
    if @selectFirst.val() is @selectSecond.val()
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
    
  selectFirstChanged: (ev) =>
    ev.preventDefault()
    if @mode isnt "accepted"
      return
    if @validate() is true
      @submitButtonDisplayed = true
      @submitButton.show()
    else 
      @submitButtonDisplayed = false
      @submitButton.hide()
    
  selectSecondChanged: (ev) =>
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