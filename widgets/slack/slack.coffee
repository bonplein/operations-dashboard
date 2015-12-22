class Dashing.Slack extends Dashing.Widget

  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()

  onData: (data) ->
    $(@node).find('.more-info').text( $(@node).find('li .value').text() + "/" + $(@node).find('li').length + " Users Online" )
