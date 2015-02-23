class Dashing.Queues extends Dashing.Widget
  @accessor 'value'

  ready: ->
    console.log("READY")
    @onData({ value: 0 })
  
  onData: (dataFull) ->
    data = dataFull.value

    id            = @get("id")
    yellowWarning = @get("yellow")
    redWarning    = @get("red")

    transition_delay = 5000
    barPadding = 2
    padding = 2
    topPadding = 20

    if (!data)
      data = @get("value")
      $(@node).find('p').addClass('flagerror')
    else
      $(@node).find('p').removeClass('flagerror')

    if (!data)
      return

    container = $(@node).parent()
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))

    width = width - 40
    height = height - 60

    if ($(@node).find("svg").length == 0)
      d3.select(@node)
        .append("svg")
        .attr("id", id)
        .data([data])
        .attr("width", width)
        .attr("height", height)

    svg = d3.select(@node).select("##{id}")

    rects = svg.selectAll("rect");

    if (data.length != rects.size())
      svg.selectAll("rect")
        .data([])
        .exit()
        .remove()

      svg.selectAll("text")
        .data([])
        .exit()
        .remove()

      svg.selectAll("rect")
        .data(data)
        .enter()
        .append("rect")
        .attr("opacity", "0")
        .attr("x", (d,i) -> 
          return padding + i * ((width - 2*padding)  / data.length)
        )
        .attr("width", width / data.length - barPadding)

      svg.selectAll("text")
        .data(data)
        .enter()
        .append("text")
        .attr("class", "bartitle")
        .attr("opacity", "0")
        .attr("x", (d, i) ->
          return i * (width / data.length) + (width / data.length - barPadding) / 2
        )
        .text((d) ->
          return d.name
        )
        .attr("text-anchor", "middle")

      svg.selectAll("g")
       .remove()

      svg.append("g")
        .attr("transform", "translate(" + padding + ",0)")
        .attr('id', 'yaxis')

    maxValue = d3.max([ 100, d3.max(data, (d) ->
      return d.val
    )])

    yScale = d3.scale.linear()
      .domain([0, maxValue])
      .range([height - 1, topPadding])

    color = d3.scale.linear()
      .domain([0, yellowWarning, redWarning])
      .range(["green", "yellow", "red"])

    svg.selectAll("rect")
      .data(data)
      .transition()
      .ease('cubic-out')
      .duration(transition_delay)
      .attr("y", (d) ->
        return yScale(d.val)
      )
      .attr("height", (d) ->
         return height - yScale(d.val)
      )
      .attr("fill", (d) ->
         return color(d.val)
      )
      .attr("opacity", "1")      

    svg.selectAll("text")
      .data(data)
      .transition()
      .ease('cubic-out')
      .duration(transition_delay)
      .attr("y", (d) ->
        return d3.min([ height - 5, yScale(d.val) + 10 ])
      )
      .attr("opacity", "1")

    
    yAxis = d3.svg.axis()
      .scale(yScale)
      .orient("right")
      .tickValues([ maxValue / 2, maxValue ])
#      .tickValues([ d3.max(data, (d) ->
#        return d.val
#      )])
      .tickFormat(d3.format(",.2r"))

    svg.select("#yaxis")
      .transition()
      .ease('cubic-out')
      .duration(transition_delay)
      .call(yAxis)
