package art;

/**
 * Circular Wave Patterns - Concentric circles with connecting lines
 */
class CC077 extends CCBase implements ICCBase {

	var nodes : Array<Circle> = [];
	var numRings = 5;
	var nodesPerRing = 12;
	var baseRadius = 50;
	var waveOffset = 0.0;
	var maxDistance = 150;
	
	var _bgColor : RGB = null;
	var _lineColor : RGB = null;
	var _nodeColor : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Circular wave patterns';
		type = [ANIMATION];
	}

	function createNode(ring:Int, index:Int):Circle {
		var angle = (index / nodesPerRing) * 360;
		var radius = baseRadius + (ring * 60);
		
		var node : Circle = {
			_id: Std.string(ring * 100 + index),
			_type: 'node',
			x: w/2 + Math.cos(radians(angle)) * radius,
			y: h/2 + Math.sin(radians(angle)) * radius,
			radius: radius,
			size: 4,
			alpha: 1.0
		}
		Reflect.setField(node, 'ring', ring);
		Reflect.setField(node, 'index', index);
		Reflect.setField(node, 'baseRadius', radius);
		
		return node;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_lineColor = hex2RGB(colorArray[1]);
		_nodeColor = hex2RGB(colorArray[2]);

		nodes = [];
		for (ring in 0...numRings) {
			for (i in 0...nodesPerRing) {
				nodes.push(createNode(ring, i));
			}
		}
	}

	function drawPattern(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		waveOffset += 0.03;
		
		// Update positions with wave effect
		for (i in 0...nodes.length) {
			var node = nodes[i];
			var ring:Int = Reflect.field(node, 'ring');
			var index:Int = Reflect.field(node, 'index');
			var baseRad:Float = Reflect.field(node, 'baseRadius');
			
			var angle = (index / nodesPerRing) * 360;
			var wave = Math.sin(waveOffset + (ring * 0.5)) * 15;
			var currentRadius = baseRad + wave;
			
			node.x = w/2 + Math.cos(radians(angle)) * currentRadius;
			node.y = h/2 + Math.sin(radians(angle)) * currentRadius;
		}
		
		// Draw connections
		for (i in 0...nodes.length) {
			var n1 = nodes[i];
			
			for (j in (i+1)...nodes.length) {
				var n2 = nodes[j];
				var dist = distance(n1.x, n1.y, n2.x, n2.y);
				
				if (dist < maxDistance) {
					var alpha = 0.4 - (dist / maxDistance);
					ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, alpha);
					ctx.lineWidth = 1;
					ctx.line(n1.x, n1.y, n2.x, n2.y);
				}
			}
		}
		
		// Draw nodes
		for (i in 0...nodes.length) {
			var node = nodes[i];
			ctx.fillStyle = getColourObj(_nodeColor, 0.8);
			ctx.fillCircle(node.x, node.y, node.size);
		}
	}

	override function draw(){
		drawPattern();
	}
}
