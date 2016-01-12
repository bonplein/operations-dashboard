class Dashing.Git extends Dashing.Widget

  dataG = null

  ready: ->
    this.fillMilestones()
    null


  onData: (data) ->
    dataG = data
    this.fillMilestones()
    null

  fillMilestones: ->
    if $(@node).find("div").length != 0
      counter = 0
      $(dataG.repos).each ->
        milestoneContent = ""
        $(this.milestones).each (miles) ->
          milestoneContent += "<p><span style='float:left;'>" + this.title + "</span><span style='float: right; padding-right: 0px;'>" + this.open + "</span><span style='float: right; padding-right: 12px;'>" + this.closed + "</span></p>"
        $(".widget-git").find(".milestone")[counter].innerHTML = milestoneContent
        counter += 1
        null
    null
