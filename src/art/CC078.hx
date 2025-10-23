package art;

/**
 * Breathing Triangles - Geometric triangles that expand and contract
 */
class CC078 extends CCBase implements ICCBase {

	var triangles : Array<Polygon> = [];
	var numTriangles = 6;
	var breathOffset = 0.0;
	
	var _bgColor : RGB = null;
	var _lineColor : RGB = null;
	var _fillColor : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Breathing triangles';
		type = [ANIMATION];
	}

	function createTriangle(i:Int):Polygon {
		var angle = (i / numTriangles) * 360;
		var distance = 150;
		
		var tri : Polygon = {
			_id: Std.string(i),
			_type: 'triangle',
			x: w/2 + Math.cos(radians(angle)) * distance,
			y: h/2 + Math.sin(radians(angle)) * distance,
			size: 60,
			sides: 3,
			rotation: angle,
			alpha: 0.7
		}
		Reflect.setField(tri, 'baseSize', 60);
		Reflect.setField(tri, 'phaseOffset', i * 0.5);
		
		return tri;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_lineColor = hex2RGB(colorArray[1]);
		_fillColor = hex2RGB(colorArray[2]);

		triangles = [];
		for (i in 0...numTriangles) {
			triangles.push(createTriangle(i));
		}
	}

	function drawTriangle(tri:Polygon) {
		var sides = 3;
		var angle = 360 / sides;
		
		ctx.beginPath();
		
		for (i in 0...sides) {
			var a = radians(tri.rotation + (i * angle));
			var x = tri.x + Math.cos(a) * tri.size;
			var y = tri.y + Math.sin(a) * tri.size;
			
			if (i == 0) {
				ctx.moveTo(x, y);
			} else {
				ctx.lineTo(x, y);
			}
		}
		
		ctx.closePath();
		
		// Fill
		ctx.fillStyle = getColourObj(_fillColor, 0.2);
		ctx.fill();
		
		// Stroke
		ctx.strokeStyle = getColourObj(_lineColor, tri.alpha);
		ctx.lineWidth = 2;
		ctx.stroke();
	}

	function drawTriangles(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		breathOffset += 0.02;
		
		// Update sizes with breathing effect
		for (i in 0...triangles.length) {
			var tri = triangles[i];
			var baseSize:Float = Reflect.field(tri, 'baseSize');
			var phaseOffset:Float = Reflect.field(tri, 'phaseOffset');
			
			var breath = Math.sin(breathOffset + phaseOffset) * 20;
			tri.size = baseSize + breath;
			tri.rotation += 0.2;
		}
		
		// Draw connection lines between centers
		for (i in 0...triangles.length) {
			var t1 = triangles[i];
			var t2 = triangles[(i + 1) % triangles.length];
			
			ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, 0.3);
			ctx.lineWidth = 1;
			ctx.line(t1.x, t1.y, t2.x, t2.y);
		}
		
		// Draw triangles
		for (i in 0...triangles.length) {
			drawTriangle(triangles[i]);
		}
		
		// Draw center point
		ctx.fillStyle = getColourObj(_lineColor, 0.5);
		ctx.fillCircle(w/2, h/2, 8);
	}

	override function draw(){
		drawTriangles();
	}
}
