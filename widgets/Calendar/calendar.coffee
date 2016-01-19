class Dashing.Calendar extends Dashing.Widget

  dataG = null

  ready: ->
    console.log("calendar started")
    this.visualize()
    null

  onData: (data) ->
    dataG = data
    console.log (data)
    this.visualize()
    null

  visualize: ->
    if dataG != null
      $(".widget-calendar").find(".calendar-name").remove()
      $(".widget-calendar").find(".calendar-bubbles-line").remove()
      prevHost = ""
      bubblesLine = "<div class='calendar-bubbles-line'>"
      $(dataG.events).each (event) ->
        console.log(this.hostCalendar)

        if prevHost == this.hostCalendar || prevHost == ""
          if prevHost == ""
            prevHost = this.hostCalendar
          bubblesLine += "<div class='calendar-bubbles-item'>" + this.event.summary + "</div>"

        else
          bubblesLine += "</div>"
          $(".widget-calendar").find(".calendar-names").append("<div class='calendar-name'>" + prevHost + "</div>")
          $(".widget-calendar").find(".calendar-bubbles").append(bubblesLine)
          bubblesLine = "<div class='calendar-bubbles-line'><div class='calendar-bubbles-item'>" + this.event.summary + "</div>"
          prevHost = this.hostCalendar

      bubblesLine += "</div>"
      $(".widget-calendar").find(".calendar-names").append("<div class='calendar-name'>" + prevHost + "</div>")
      $(".widget-calendar").find(".calendar-bubbles").append(bubblesLine)
      null
    else
      null
