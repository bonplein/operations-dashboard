class Dashing.Git extends Dashing.Widget

  counterG = 0

  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()

  onData: (data) ->
    console.log(data)
    setTimeout (timedjQuery data), 500000000
    counter = 0
    $(@node).find(".milestone").text("asdasdasd")
    $(data.repos).each (repo) ->
      $(this.milestones).each (miles) ->
        mile = $(@node).find(".milestone")[counter]
        $(@node).find(".milestone").css("color", "blue")
        console.log(this)
      counter += 1
    $(@node).find(".milestone")

  timedjQuery = (data) ->
    console.log("hehe im late", data)
