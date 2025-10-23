package art;

/**
 * Particle Wave Effect - Animated sine wave particles
 */
class CC072 extends CCBase implements ICCBase {

	var particles : Array<Particle> = [];
	var numParticles = 80;
	var waveOffset = 0.0;
	
	var _bgColor : RGB = null;
	var _particleColor : RGB = null;
	var _particleColor2 : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Particle wave effect';
		type = [ANIMATION];
	}

	function createParticle(i:Int):Particle {
		var spacing = w / numParticles;
		var particle : Particle = {
			_id: Std.string(i),
			_type: 'particle',
			x: i * spacing,
			y: h/2,
			baseY: h/2,
			size: randomInt(3, 8),
			speed: random(0.02, 0.05),
			amplitude: randomInt(100, 200),
			offset: i * 0.1,
			alpha: random(0.6, 1.0)
		}
		return particle;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		// Setup colors
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_particleColor = hex2RGB(colorArray[1]);
		_particleColor2 = hex2RGB(colorArray[2]);

		// Create particles
		particles = [];
		for (i in 0...numParticles) {
			particles.push(createParticle(i));
		}
	}

	function drawParticles(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		// Update wave offset
		waveOffset += 0.03;
		
		// Draw connections
		ctx.beginPath();
		ctx.strokeStyle = getColourObj(_particleColor, 0.3);
		ctx.lineWidth = 2;
		
		for (i in 0...particles.length) {
			var p = particles[i];
			p.y = p.baseY + Math.sin(waveOffset + p.offset) * p.amplitude;
			
			if (i == 0) {
				ctx.moveTo(p.x, p.y);
			} else {
				ctx.lineTo(p.x, p.y);
			}
		}
		ctx.stroke();
		
		// Draw particles
		for (i in 0...particles.length) {
			var p = particles[i];
			
			// Alternate colors
			var color = (i % 2 == 0) ? _particleColor : _particleColor2;
			ctx.fillStyle = getColourObj(color, p.alpha);
			ctx.fillCircle(p.x, p.y, p.size);
			
			// Add glow effect
			ctx.fillStyle = getColourObj(color, p.alpha * 0.3);
			ctx.fillCircle(p.x, p.y, p.size * 2);
		}
	}

	override function draw(){
		drawParticles();
	}
}
