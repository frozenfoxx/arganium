App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  # Called when there's incoming data on the websocket for this channel
  received: (data) ->
    switch
      when data['message']? then $('#messages').append data['message']
      when data['challengeid']? then App.room.changebutton data
      else console.log "Unhandled data on room_channel"

  activatecheat: ->
    # alert("Cheat accepted")
    @perform 'activatecheat'

  changebutton: (data) ->
    buttonid = "#challengeButton" + data['challengeid']
    buttonClass = ""

    switch
      when data['solved'] is true then buttonClass = "btn btn-success"
      when data['locked'] is false then buttonClass = "btn btn-primary"
      when data['locked'] is true then buttonClass = "btn btn-danger"

    $(buttonid).attr("class", buttonClass)

  subflag: (data) ->
    @perform 'subflag', message: data.target.value, id: data.target.challengeid

  subpowerup: (data) ->
    @perform 'subpowerup', powerup: data.target.powerup, area: data.target.poweruparea

  raisehacklift: (sectorid) ->
    @perform 'raisehacklift', message: sectorid

  lowerhacklift: (sectorid) ->
    @perform 'lowerhacklift', message: sectorid

$(document).on 'click', '[data-behavior~=room_raiser]', (event) ->
  App.room.raisehacklift event.target.value

$(document).on 'click', '[data-behavior~=room_lower]', (event) ->
  App.room.lowerhacklift event.target.value

$(document).on 'click', '[data-behavior~=submit_powerup]', (event) ->
  event.target.powerup = $('input[name="powerup"]:checked').val()
  event.target.poweruparea = $('input[name="poweruparea"]:checked').val()
  App.room.subpowerup event

$(document).on 'click', '[data-behavior~=submit_flag]', (event) ->
  if event.target.type is "button"
    event.target.challengeid = $(this).attr('data-challengeid')

    # Find which input box matches this button
    inputbox = "#challengeModalInput" + event.target.challengeid
    event.target.value = $(inputbox).val()

    App.room.subflag event
    event.target.value = ""
    event.target.challengeid = ""
    event.preventDefault()

$(document).on 'keypress', '[data-behavior~=submit_flag]', (event) ->
  if event.keyCode is 13 # return = send
    event.target.challengeid = $(this).attr('data-challengeid')
    App.room.subflag event
    event.target.value = ""
    event.target.challengeid = ""
    event.preventDefault()
