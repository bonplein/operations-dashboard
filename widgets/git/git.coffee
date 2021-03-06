class Dashing.Git extends Dashing.Widget

  dataG = null

  ready: ->
    $("head").append("<link rel='stylesheet' href='/assets/octicons/octicons.css'>")
    this.fillMilestones()
    null


  onData: (data) ->
    dataG = data
    this.fillMilestones()
    null

  fillMilestones: ->
    if $(@node).find("div").length != 0 && dataG != null
      counter = 0
      $(dataG.repos).each ->
        milestoneContent = ""
        $(this.milestones).each (miles) ->
          dueOn = new Date(Date.parse(this.due))
          milestoneContent += "<div class='milestone'><span class='milestoneName'>" + this.title + "</span><span class='milestoneOpen'>" + this.open + "</span><span class='milestoneClosed'>" + this.closed + "</span><span class='milestoneDue'>" + dueOn.toLocaleDateString() + "</span></div>"
        $(".widget-git").find(".milestones")[counter].innerHTML = milestoneContent
        counter += 1
        null
    null
