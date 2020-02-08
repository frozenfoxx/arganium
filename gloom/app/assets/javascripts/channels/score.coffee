App.score = App.cable.subscriptions.create "ScoreChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  # Called when there's incoming data on the websocket for this channel
  received: (data) ->
    switch
      when data['time']? then $('#time').text data['time']
      when data['kills']? then $('#kills').text data['kills']
      when data['secrets']? then $('#secrets').text data['secrets']
      when data['challenges']? then $('#challenges').text data['challenges']
      when data['total']? then $('#total').text data['total']
      else console.log "Unhandled data on score_channel"
