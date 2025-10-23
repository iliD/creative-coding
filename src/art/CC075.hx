package art;

/**
 * Rotating Connected Polygons - Geometric shapes with connecting lines
 */
class CC075 extends CCBase implements ICCBase {

	var shapes : Array<Circle> = [];
	var numShapes = 8;
	var centerRadius = 200;
	var rotationSpeed = 0.5;
	var currentAngle = 0.0;
	var maxDistance = 250;
	
	var _bgColor : RGB = null;
	var _lineColor : RGB = null;
	var _nodeColor : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Rotating connected polygons';
		type = [ANIMATION];
	}

	function createShape(i:Int):Circle {
		var angle = (i / numShapes) * 360;
		var shape : Circle = {
			_id: Std.string(i),
			_type: 'circle',
			x: w/2 + Math.cos(radians(angle)) * centerRadius,
			y: h/2 + Math.sin(radians(angle)) * centerRadius,
			size: 8,
			alpha: 1.0
		}
		return shape;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_lineColor = hex2RGB(colorArray[1]);
		_nodeColor = hex2RGB(colorArray[2]);

		shapes = [];
		for (i in 0...numShapes) {
			shapes.push(createShape(i));
		}
	}

	function drawShapes(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		currentAngle += rotationSpeed;
		
		// Update positions
		for (i in 0...shapes.length) {
			var angle = (i / numShapes) * 360 + currentAngle;
			shapes[i].x = w/2 + Math.cos(radians(angle)) * centerRadius;
			shapes[i].y = h/2 + Math.sin(radians(angle)) * centerRadius;
		}
		
		// Draw connections
		for (i in 0...shapes.length) {
			var s1 = shapes[i];
			
			for (j in (i+1)...shapes.length) {
				var s2 = shapes[j];
				var dist = distance(s1.x, s1.y, s2.x, s2.y);
				
				if (dist < maxDistance) {
					var alpha = 0.6 - (dist / maxDistance);
					ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, alpha);
					ctx.lineWidth = 1;
					ctx.line(s1.x, s1.y, s2.x, s2.y);
				}
			}
		}
		
		// Draw nodes
		for (i in 0...shapes.length) {
			var s = shapes[i];
			ctx.fillStyle = getColourObj(_nodeColor, 0.8);
			ctx.fillCircle(s.x, s.y, s.size);
			
			// Glow
			ctx.fillStyle = getColourObj(_nodeColor, 0.3);
			ctx.fillCircle(s.x, s.y, s.size * 2);
		}
	}

	override function draw(){
		drawShapes();
	}
}
