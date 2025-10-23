package art;

/**
 * Flowing Ribbons - Smooth flowing curves with gradients
 */
class CC074 extends CCBase implements ICCBase {

	var ribbons : Array<Ribbon> = [];
	var numRibbons = 5;
	var time = 0.0;
	
	var _bgColor : RGB = null;
	var colorPalette : Array<RGB> = [];

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Flowing ribbon curves';
		type = [ANIMATION];
	}

	function createRibbon(i:Int):Ribbon {
		var ribbon : Ribbon = {
			_id: Std.string(i),
			_type: 'ribbon',
			points: [],
			yOffset: (h / (numRibbons + 1)) * (i + 1),
			speed: random(0.01, 0.03),
			amplitude: random(50, 150),
			frequency: random(0.005, 0.015),
			thickness: randomInt(20, 40),
			colorIndex: i % colorPalette.length
		}
		
		// Create points along the ribbon
		for (x in 0...Std.int(w + 50)) {
			if (x % 5 == 0) {
				ribbon.points.push({x: x, y: 0});
			}
		}
		
		return ribbon;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		// Setup colors
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		
		for (i in 1...5) {
			if (colorArray[i] != null) {
				colorPalette.push(hex2RGB(colorArray[i]));
			}
		}
		
		// Create ribbons
		ribbons = [];
		for (i in 0...numRibbons) {
			ribbons.push(createRibbon(i));
		}
	}

	function drawRibbons(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		time += 0.02;
		
		for (ribbon in ribbons) {
			// Update ribbon points
			for (i in 0...ribbon.points.length) {
				var point = ribbon.points[i];
				var x = point.x;
				point.y = ribbon.yOffset + Math.sin(time + (x * ribbon.frequency)) * ribbon.amplitude;
			}
			
			// Draw ribbon with smooth curves
			ctx.beginPath();
			var color = colorPalette[ribbon.colorIndex];
			ctx.strokeStyle = getColourObj(color, 0.7);
			ctx.lineWidth = ribbon.thickness;
			ctx.lineCap = 'round';
			ctx.lineJoin = 'round';
			
			// Start path
			if (ribbon.points.length > 0) {
				ctx.moveTo(ribbon.points[0].x, ribbon.points[0].y);
				
				// Draw smooth curve through points
				for (i in 1...ribbon.points.length) {
					var xc = (ribbon.points[i].x + ribbon.points[i - 1].x) / 2;
					var yc = (ribbon.points[i].y + ribbon.points[i - 1].y) / 2;
					ctx.quadraticCurveTo(ribbon.points[i - 1].x, ribbon.points[i - 1].y, xc, yc);
				}
			}
			
			ctx.stroke();
			
			// Draw with lighter overlay for glow effect
			ctx.strokeStyle = getColourObj(color, 0.3);
			ctx.lineWidth = ribbon.thickness * 1.5;
			ctx.stroke();
		}
	}

	override function draw(){
		drawRibbons();
	}
}
