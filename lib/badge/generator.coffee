Canvas = require 'canvas'
QRCode = require 'qrcode'
fs = require 'fs'
util = require 'util'

qr_scale = 23
qr_dimension = 37
qr_width = qr_scale * qr_dimension

# large badge dimensions: 1300 x 1655
# allows us to print a standard badge at 300dpi
[width, height] = [1300, 1655]

footer_height = 200

## support routines
create_qr_canvas = ( text ) ->
  d = QRCode.QRCodeDraw
  d.scale = qr_scale
  d.defaultMargin = 0
  d.marginScaleFactor = 0
  qr_canvas = null
  # continuation passing style
  QRCode.draw text, (err,res) -> qr_canvas = res
  qr_canvas

# saves a canvas as PNG on disk
save_canvas_as_png = ( canvas, path, cb ) ->
  out = fs.createWriteStream path
  stream = canvas.createPNGStream()
  stream.on 'data', (chunk) -> out.write chunk
  stream.on 'end', -> cb?()

# pumps a canvas through an HTTP response as image/png
respond_canvas_as_png = ( canvas, res ) ->
  res.headers['Content-Type'] = 'image/png'
  # TODO: content length?
  util.pump canvas.createPNGStream(), res

generate_badge_canvas = ( uri, name, twitter, tagline ) ->
  ## create canvas/context
  canvas = new Canvas width, height
  ctx = canvas.getContext '2d'
  ## fill background white
  ctx.fillStyle = 'white'
  ctx.fillRect 0, 0, width, height
  ## add name
  ctx.fillStyle = 'black'
  ctx.font = '120px Verdana'
  te = ctx.measureText name
  ctx.fillText name, (width - te.width) / 2, 150
  ## add twitter
  if twitter?
    ctx.fillStyle = '#444'
    ctx.font = '80px Verdana'
    te = ctx.measureText twitter
    ctx.fillText twitter, (width - te.width) / 2, 300
  ## add QR code
  qr_canvas = create_qr_canvas uri
  qr_x = (width - qr_width) / 2
  qr_y = height - footer_height - qr_width - 100
  ctx.drawImage qr_canvas, qr_x, qr_y
  ## add footer image
  footer_img = new Canvas.Image
  footer_img.src = __dirname + '/badge-footer.png'
  ctx.drawImage footer_img, 0, height - footer_height
  ## add border stroke
  ctx.lineWidth = 5
  ctx.strokeStyle = 'black'
  ctx.strokeRect 0, 0, width, height
  # return canvas
  canvas

exports.generate_badge_canvas = generate_badge_canvas
exports.save_canvas_as_png = save_canvas_as_png
exports.respond_canvas_as_png = respond_canvas_as_png

### notes:

http://mapochovalley.com/badge/84938439

gr = ctx.createLinearGradient 0, 0, 0, 500
gr.addColorStop 0, '#999'
gr.addColorStop 1, '#fff'
ctx.fillStyle = gr

console.log canvas.toDataURL()
save_canvas_as_png canvas, __dirname + '/test1.png', ->
  console.log 'saved png'
###


