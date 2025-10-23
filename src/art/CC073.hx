package art;

/**
 * Spiral Galaxy Effect - Rotating spiral with particles
 */
class CC073 extends CCBase implements ICCBase {

	var stars : Array<Star> = [];
	var numArms = 3;
	var numStars = 300;
	var rotation = 0.0;
	
	var _bgColor : RGB = null;
	var _starColor : RGB = null;
	var _starColor2 : RGB = null;
	var _coreColor : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Spiral galaxy effect';
		type = [ANIMATION];
	}

	function createStar(i:Int):Star {
		var armIndex = i % numArms;
		var armAngle = (armIndex / numArms) * Math.PI * 2;
		var distance = random(20, 300);
		var angle = armAngle + (distance * 0.02);
		
		var star : Star = {
			_id: Std.string(i),
			_type: 'star',
			distance: distance,
			angle: angle,
			baseAngle: angle,
			x: 0,
			y: 0,
			size: random(1, 4),
			speed: random(0.001, 0.003),
			alpha: random(0.3, 1.0),
			armIndex: armIndex
		}
		return star;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		// Setup colors
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_starColor = hex2RGB(colorArray[1]);
		_starColor2 = hex2RGB(colorArray[2]);
		_coreColor = hex2RGB(colorArray[3]);

		// Create stars
		stars = [];
		for (i in 0...numStars) {
			stars.push(createStar(i));
		}
	}

	function drawGalaxy(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		// Update rotation
		rotation += 0.005;
		
		// Draw stars
		for (i in 0...stars.length) {
			var s = stars[i];
			
			// Calculate position
			var totalAngle = s.baseAngle + rotation + (s.distance * 0.01);
			s.x = w/2 + Math.cos(totalAngle) * s.distance;
			s.y = h/2 + Math.sin(totalAngle) * s.distance;
			
			// Fade based on distance from center
			var fadeAlpha = s.alpha * (1 - (s.distance / 350));
			
			// Color based on arm
			var color = (s.armIndex % 2 == 0) ? _starColor : _starColor2;
			
			// Draw star with glow
			ctx.fillStyle = getColourObj(color, fadeAlpha * 0.3);
			ctx.fillCircle(s.x, s.y, s.size * 3);
			
			ctx.fillStyle = getColourObj(color, fadeAlpha);
			ctx.fillCircle(s.x, s.y, s.size);
		}
		
		// Draw bright core
		var coreSize = 30;
		ctx.fillStyle = getColourObj(_coreColor, 0.1);
		ctx.fillCircle(w/2, h/2, coreSize * 3);
		ctx.fillStyle = getColourObj(_coreColor, 0.3);
		ctx.fillCircle(w/2, h/2, coreSize * 2);
		ctx.fillStyle = getColourObj(_coreColor, 0.8);
		ctx.fillCircle(w/2, h/2, coreSize);
	}

	override function draw(){
		drawGalaxy();
	}
}
