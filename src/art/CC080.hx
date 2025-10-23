package art;

/**
 * ILID Text Animation - Clean, soothing letter transitions inspired by CC012
 */
class CC080 extends CCBase implements ICCBase {
	var lines : Array<Line> = [];
	var currentLetter = 0;
	var letters = ['I', 'L', 'I', 'D'];
	var letterAlpha = 1.0;
	var transitionTimer = 0.0;
	var displayDuration = 4.0; // how long to show each letter
	var fadeDuration = 1.0; // how long fade takes
	
	var maxDistance:Int = 120;
	var centerRadius:Int = 280;
	var innerRadius:Int = 50;
	
	var _bgColor : RGB = null;
	var _lineColor : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'ILID - slow soothing text';
		type = [ANIMATION];
	}

	function getLetterLines(letter:String):Array<Line> {
		var letterLines:Array<Line> = [];
		var segmentLength = 70;
		var spacing = 35;
		
		switch(letter) {
			case 'I':
				letterLines.push({
					_id: 0,
					x1: w/2,
					y1: h/2 - segmentLength,
					x2: w/2,
					y2: h/2 + segmentLength,
					stroke: 3
				});
			
			case 'L':
				letterLines.push({
					_id: 0,
					x1: w/2 - spacing,
					y1: h/2 - segmentLength,
					x2: w/2 - spacing,
					y2: h/2 + segmentLength,
					stroke: 3
				});
				letterLines.push({
					_id: 1,
					x1: w/2 - spacing,
					y1: h/2 + segmentLength,
					x2: w/2 + spacing + 15,
					y2: h/2 + segmentLength,
					stroke: 3
				});
			
			case 'D':
				letterLines.push({
					_id: 0,
					x1: w/2 - spacing,
					y1: h/2 - segmentLength,
					x2: w/2 - spacing,
					y2: h/2 + segmentLength,
					stroke: 3
				});
				letterLines.push({
					_id: 1,
					x1: w/2 - spacing,
					y1: h/2 - segmentLength,
					x2: w/2 + spacing - 5,
					y2: h/2 - segmentLength,
					stroke: 3
				});
				letterLines.push({
					_id: 2,
					x1: w/2 - spacing,
					y1: h/2 + segmentLength,
					x2: w/2 + spacing - 5,
					y2: h/2 + segmentLength,
					stroke: 3
				});
				letterLines.push({
					_id: 3,
					x1: w/2 + spacing - 5,
					y1: h/2 - segmentLength,
					x2: w/2 + spacing - 5,
					y2: h/2 + segmentLength,
					stroke: 3
				});
		}
		
		return letterLines;
	}

	function createRadialLines(numLines:Int):Array<Line> {
		var radialLines:Array<Line> = [];
		var divide = 360 / numLines;
		
		for (i in 0...numLines) {
			var angle = i * divide;
			var line:Line = {
				_id: i,
				x1: (w / 2) + Math.cos(radians(angle)) * centerRadius,
				y1: (h / 2) + Math.sin(radians(angle)) * centerRadius,
				x2: (w / 2) + Math.cos(radians(angle)) * innerRadius,
				y2: (h / 2) + Math.sin(radians(angle)) * innerRadius,
				stroke: 1,
				radius: random(centerRadius * 0.75, centerRadius * 0.9)
			}
			animateLine(line);
			radialLines.push(line);
		}
		
		return radialLines;
	}

	function animateLine(line:Line) {
		Go.to(line, random(4, 6))
			.prop('radius', random(centerRadius * 0.75, centerRadius * 0.9))
			.ease(Sine.easeInOut)
			.onComplete(animateLine, [line]);
	}

	override function setup(){
		trace('setup: ' + toString());
		
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_lineColor = hex2RGB(colorArray[1]);

		lines = createRadialLines(50);
	}

	function drawLetter(){
		var letter = letters[currentLetter];
		var letterLines = getLetterLines(letter);
		
		// Draw letter with current alpha
		for (line in letterLines) {
			ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, letterAlpha);
			ctx.lineWidth = line.stroke;
			ctx.lineCap = 'round';
			ctx.line(line.x1, line.y1, line.x2, line.y2);
			
			// Draw endpoint circles
			ctx.fillStyle = getColourObj(_lineColor, letterAlpha * 0.8);
			ctx.fillCircle(line.x1, line.y1, 6);
			ctx.fillCircle(line.x2, line.y2, 6);
		}
	}

	function drawRadialLines(){
		for (i in 0...lines.length) {
			var line = lines[i];
			var angle = (i / lines.length) * 360;
			line.x2 = (w / 2) + Math.cos(radians(angle)) * line.radius;
			line.y2 = (h / 2) + Math.sin(radians(angle)) * line.radius;
			
			ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, 0.25);
			ctx.lineWidth = line.stroke;
			ctx.line(line.x1, line.y1, line.x2, line.y2);

			// Draw endpoint circles
			ctx.fillStyle = getColourObj(_lineColor, 0.4);
			ctx.fillCircle(line.x2, line.y2, 3);

			// Draw connections between nearby endpoints
			for (j in (i+1)...lines.length) {
				var line2 = lines[j];
				
				var dist = distance(line.x2, line.y2, line2.x2, line2.y2);
				if (dist < maxDistance) {
					var alpha:Float = 0.3 - (dist / maxDistance);
					ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, alpha);
					ctx.lineWidth = 1;
					ctx.line(line.x2, line.y2, line2.x2, line2.y2);
				}
			}
		}
	}

	override function draw(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		// Update timer
		transitionTimer += 0.016; // ~60fps = 0.016s per frame
		
		// Calculate alpha based on timer
		if (transitionTimer < displayDuration - fadeDuration) {
			// Fully visible
			letterAlpha = 1.0;
		} else if (transitionTimer < displayDuration) {
			// Fading out
			var fadeProgress = (transitionTimer - (displayDuration - fadeDuration)) / fadeDuration;
			letterAlpha = 1.0 - fadeProgress;
		} else {
			// Move to next letter
			transitionTimer = 0;
			currentLetter = (currentLetter + 1) % letters.length;
			letterAlpha = 1.0;
		}
		
		drawRadialLines();
		drawLetter();
	}
}
