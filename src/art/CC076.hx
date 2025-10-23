package art;

/**
 * Pulsing Grid Lines - Minimal geometric grid with breathing animation
 */
class CC076 extends CCBase implements ICCBase {

	var gridLines : Array<Line> = [];
	var gridSize = 6;
	var spacing = 120;
	var pulseOffset = 0.0;
	
	var _bgColor : RGB = null;
	var _lineColor : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Pulsing grid lines';
		type = [ANIMATION];
	}

	function createVerticalLine(i:Int):Line {
		var x = (w/2) - (gridSize/2 * spacing) + (i * spacing);
		var line : Line = {
			_id: i,
			_type: 'vertical',
			x1: x,
			y1: h/2 - (gridSize/2 * spacing),
			x2: x,
			y2: h/2 + (gridSize/2 * spacing),
			stroke: 2
		}
		return line;
	}

	function createHorizontalLine(i:Int):Line {
		var y = (h/2) - (gridSize/2 * spacing) + (i * spacing);
		var line : Line = {
			_id: i + 100,
			_type: 'horizontal',
			x1: w/2 - (gridSize/2 * spacing),
			y1: y,
			x2: w/2 + (gridSize/2 * spacing),
			y2: y,
			stroke: 2
		}
		return line;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_lineColor = hex2RGB(colorArray[1]);

		gridLines = [];
		
		// Create vertical lines
		for (i in 0...(gridSize+1)) {
			gridLines.push(createVerticalLine(i));
		}
		
		// Create horizontal lines
		for (i in 0...(gridSize+1)) {
			gridLines.push(createHorizontalLine(i));
		}
	}

	function drawGrid(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		pulseOffset += 0.02;
		
		for (i in 0...gridLines.length) {
			var line = gridLines[i];
			
			// Calculate pulse effect based on position
			var pulse = Math.sin(pulseOffset + (i * 0.3)) * 0.3 + 0.7;
			var alpha = pulse;
			
			ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, alpha);
			ctx.lineWidth = line.stroke;
			ctx.lineCap = 'round';
			ctx.line(line.x1, line.y1, line.x2, line.y2);
		}
		
		// Draw intersection points
		for (i in 0...(gridSize+1)) {
			for (j in 0...(gridSize+1)) {
				var x = (w/2) - (gridSize/2 * spacing) + (i * spacing);
				var y = (h/2) - (gridSize/2 * spacing) + (j * spacing);
				
				var pulse = Math.sin(pulseOffset + (i * 0.3) + (j * 0.3)) * 0.4 + 0.6;
				
				ctx.fillStyle = getColourObj(_lineColor, pulse);
				ctx.fillCircle(x, y, 4);
			}
		}
	}

	override function draw(){
		drawGrid();
	}
}
