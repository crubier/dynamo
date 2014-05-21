###

dynamo
https://github.com/crubier/dynamo

Copyright (c) 2014 Vincent Lecrubier
Licensed under the MIT license.

###

'use strict'

console.log "frontend started"

Interpolation = require '../lib/interpolation.js'

console.log "bb"
			
can = document.getElementById "a"
ctx = can.getContext "2d"

can.width = 1600
can.height = 1200
can.style.width = "800px"
can.style.height = "600px"

# devicePixelRatio = window.devicePixelRatio or 1
# backingStoreRatio = ctx.webkitBackingStorePixelRatio or
    # ctx.mozBackingStorePixelRatio or ctx.msBackingStorePixelRatio or
    # ctx.oBackingStorePixelRatio or ctx.backingStorePixelRatio or 1
# ratio = devicePixelRatio / backingStoreRatio
# console.log "ratio:#{ratio}"
# # upscale the canvas if the two ratios don't match
# if devicePixelRatio isnt backingStoreRatio
#   oldWidth = can.width
#   oldHeight = can.height
#   can.width = oldWidth * ratio
#   can.height = oldHeight * ratio
#   can.style.width = oldWidth + "px"
#   can.style.height = oldHeight + "px"
  
#   # now scale the context to counter
#   # the fact that we've manually scaled
#   # our canvas element
#   ctx.scale ratio, ratio


console.time("it took")
ctx.fillStyle = "rgb(255,255,255)"
ctx.fillRect(0,0,ctx.canvas.width,ctx.canvas.height)

scaleauto = (table,mini,maxi) ->
  tablemin=table.reduce (previous,current)->
    ( if previous < current then previous else current )
  tablemax=table.reduce (previous,current)->
    ( if previous > current then previous else current )
  tablespan=Math.max(tablemax-tablemin,0.000001)
  table.map (tablevalue)->(mini+(maxi-mini)*(tablevalue-tablemin)/(tablespan))

scale = (table,mini,maxi) ->
  tablemin=-1
  tablemax=1
  tablespan=Math.max(tablemax-tablemin,0.000001)
  table.map (tablevalue)->(mini+(maxi-mini)*(tablevalue-tablemin)/(tablespan))

random = (x) -> 2*x*Math.random()-x

length=360000

generate = (sx,sy,nx,ny,rx,ry)->
  console.time("generation")
  t = [1..length].map (x)->(4*Math.PI*(x /length)-2*Math.PI)
  x = (sx*(Math.cos(nx*tt) + random(rx)) for tt in t)
  y = (sy*(Math.sin(ny*tt) + random(ry)) for tt in t)
  xscale = scale(x,0,ctx.canvas.width)
  yscale = scale(y,0,ctx.canvas.height)
  console.timeEnd("generation")
  [xscale,yscale]

render = (points,color) ->
  console.time("rendering")
  ctx.beginPath()
  ctx.moveTo(points[0][0],points[1][0])
  (ctx.lineTo(points[0][i],points[1][i])   ) for i in [1..length-1]
  ctx.strokeStyle = color
  ctx.stroke()
  ctx.closePath()
  console.timeEnd("rendering")

prepare = (points) ->
  x=[]
  y=[]
  for v in points
    x.push Number(v[0])
    y.push Number(v[1])
  x=scaleauto(x,0,ctx.canvas.width)
  y=scaleauto(y,0,ctx.canvas.height/4)
  [x,y]

n=2
render(
  generate(random(1),random(1),random(10),random(10),random(0.1),random(0.1)),
  "HSLa(#{i*360/n},100%,50%,0.01)"
  ) for i in [0..n-1]
console.timeEnd("it took")

trig = document.getElementById "trigg"
trig.addEventListener "click", ()->
  ctx.canvas.width = ctx.canvas.width
# console.log scaleauto.prototype.constructor

# console.log "loll"

# console.log scaleauto
filepicker = document.getElementById 'csvFileInput'
filepicker.addEventListener "change", ()->
  handleFiles(filepicker.files)

handleFiles = (files) ->
  # Check for the various File API support.
  if window.FileReader
    
    # FileReader are supported.
    getAsText files[0]
  else
    alert "FileReader are not supported in this browser."
  return

getAsText = (fileToRead) ->
  reader = new FileReader()
  
  # Read file into memory as UTF-8
  reader.readAsText fileToRead
  
  # Handle errors load
  reader.onload = loadHandler
  reader.onerror = errorHandler
  return

loadHandler = (event) ->
  csv = event.target.result
  processData csv
  return

processData = (csv) ->
  console.time "parsecsv"
  allTextLines = csv.split(/\r\n|\n/)
  lines = []
  i = 0
  while i < allTextLines.length
    data = allTextLines[i].split(",")
    tarr = []
    j = 0

    while j < data.length
      tarr.push data[j]
      j++
    lines.push tarr
    i++
  data=prepare(lines)
  console.timeEnd "parsecsv"
  render(data,"rgb(255,0,0)")
  return

errorHandler = (evt) ->
  alert "Canno't read file !"  if evt.target.error.name is "NotReadableError"
  return








console.log "frontend stopped"