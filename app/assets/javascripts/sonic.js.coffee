(->
  Sonic = (d) ->
    @data = d.path or d.data
    @imageData = []
    @multiplier = d.multiplier or 1
    @padding = d.padding or 0
    @fps = d.fps or 25
    @stepsPerFrame = ~~d.stepsPerFrame or 1
    @trailLength = d.trailLength or 1
    @pointDistance = d.pointDistance or .05
    @domClass = d.domClass or "sonic"
    @fillColor = d.fillColor or "#FFF"
    @strokeColor = d.strokeColor or "#FFF"
    @stepMethod = (if typeof d.step is "string" then stepMethods[d.step] else d.step or stepMethods.square)
    @_setup = d.setup or emptyFn
    @_teardown = d.teardown or emptyFn
    @_preStep = d.preStep or emptyFn
    @width = d.width
    @height = d.height
    @fullWidth = @width + 2 * @padding
    @fullHeight = @height + 2 * @padding
    @domClass = d.domClass or "sonic"
    @setup()
  emptyFn = ->

  argTypes = Sonic.argTypes =
    DIM: 1
    DEGREE: 2
    RADIUS: 3
    OTHER: 0

  argSignatures = Sonic.argSignatures =
    arc: [1, 1, 3, 2, 2, 0]
    bezier: [1, 1, 1, 1, 1, 1, 1, 1]
    line: [1, 1, 1, 1]

  pathMethods = Sonic.pathMethods =
    bezier: (t, p0x, p0y, p1x, p1y, c0x, c0y, c1x, c1y) ->
      t = 1 - t
      i = 1 - t
      x = t * t
      y = i * i
      a = x * t
      b = 3 * x * i
      c = 3 * t * y
      d = y * i
      [a * p0x + b * c0x + c * c1x + d * p1x, a * p0y + b * c0y + c * c1y + d * p1y]

    arc: (t, cx, cy, radius, start, end) ->
      point = (end - start) * t + start
      ret = [(Math.cos(point) * radius) + cx, (Math.sin(point) * radius) + cy]
      ret.angle = point
      ret.t = t
      ret

    line: (t, sx, sy, ex, ey) ->
      [(ex - sx) * t + sx, (ey - sy) * t + sy]

  stepMethods = Sonic.stepMethods =
    square: (point, i, f, color, alpha) ->
      @_.fillRect point.x - 3, point.y - 3, 6, 6

    fader: (point, i, f, color, alpha) ->
      @_.beginPath()
      @_.moveTo @_last.x, @_last.y  if @_last
      @_.lineTo point.x, point.y
      @_.closePath()
      @_.stroke()
      @_last = point

  Sonic:: =
    setup: ->
      args = undefined
      type = undefined
      method = undefined
      value = undefined
      data = @data
      @canvas = document.createElement("canvas")
      @_ = @canvas.getContext("2d")
      @canvas.className = @domClass
      @canvas.height = @fullHeight
      @canvas.width = @fullWidth
      @points = []
      i = -1
      l = data.length

      while ++i < l
        args = data[i].slice(1)
        method = data[i][0]
        if method of argSignatures
          a = -1
          al = args.length

          while ++a < al
            type = argSignatures[method][a]
            value = args[a]
            switch type
              when argTypes.RADIUS
                value *= @multiplier
              when argTypes.DIM
                value *= @multiplier
                value += @padding
              when argTypes.DEGREE
                value *= Math.PI / 180
            args[a] = value
        args.unshift 0
        r = undefined
        pd = @pointDistance
        t = pd

        while t <= 1
          
          # Avoid crap like 0.15000000000000002
          t = Math.round(t * 1 / pd) / (1 / pd)
          args[0] = t
          r = pathMethods[method].apply(null, args)
          @points.push
            x: r[0]
            y: r[1]
            progress: t

          t += pd
      @frame = 0

    
    #this.prep(this.frame);
    prep: (frame) ->
      return  if frame of @imageData
      @_.clearRect 0, 0, @fullWidth, @fullHeight
      points = @points
      pointsLength = points.length
      pd = @pointDistance
      point = undefined
      index = undefined
      indexD = undefined
      frameD = undefined
      @_setup()
      i = -1
      l = pointsLength * @trailLength

      while ++i < l and not @stopped
        index = frame + i
        point = points[index] or points[index - pointsLength]
        continue  unless point
        @alpha = Math.round(1000 * (i / (l - 1))) / 1000
        @_.globalAlpha = @alpha
        @_.fillStyle = @fillColor
        @_.strokeStyle = @strokeColor
        frameD = frame / (@points.length - 1)
        indexD = i / (l - 1)
        @_preStep point, indexD, frameD
        @stepMethod point, indexD, frameD
      @_teardown()
      @imageData[frame] = (@_.getImageData(0, 0, @fullWidth, @fullWidth))
      true

    draw: ->
      unless @prep(@frame)
        @_.clearRect 0, 0, @fullWidth, @fullWidth
        @_.putImageData @imageData[@frame], 0, 0
      @iterateFrame()

    iterateFrame: ->
      @frame += @stepsPerFrame
      @frame = 0  if @frame >= @points.length

    play: ->
      @stopped = false
      hoc = this
      @timer = setInterval(->
        hoc.draw()
      , 1000 / @fps)

    stop: ->
      @stopped = true
      @timer and clearInterval(@timer)

  window.Sonic = Sonic
)()