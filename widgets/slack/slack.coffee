class Dashing.Slack extends Dashing.Widget

  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()

  onData: (data) ->
    usersOnline = 0;
    for item in data.items
      if item.value == "active"
        usersOnline++
    $(@node).find('.more-info').text( usersOnline + "/" + $(@node).find('li').length + " Users Online" )
