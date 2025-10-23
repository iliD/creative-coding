package art;

/**
 * Linear Constellation - Moving points with elegant line connections
 */
class CC079 extends CCBase implements ICCBase {

	var nodes : Array<Ball> = [];
	var numNodes = 30;
	var maxDistance = 150;
	var nodeSize = 4;
	
	var _bgColor : RGB = null;
	var _lineColor : RGB = null;
	var _nodeColor : RGB = null;

	public function new(ctx:CanvasRenderingContext2D) {
		super(ctx);
		description = 'Linear constellation';
		type = [ANIMATION];
	}

	function createNode(i:Int):Ball {
		var node : Ball = {
			_id: Std.string(i),
			_type: 'node',
			x: random(100, w-100),
			y: random(100, h-100),
			speed_x: random(-0.3, 0.3),
			speed_y: random(-0.3, 0.3),
			size: random(nodeSize, nodeSize * 2),
			alpha: random(0.6, 1.0)
		}
		return node;
	}

	override function setup(){
		trace('setup: ' + toString());
		
		var colorArray = ColorUtil.niceColor100[randomInt(ColorUtil.niceColor100.length-1)];
		_bgColor = hex2RGB(colorArray[0]);
		_lineColor = hex2RGB(colorArray[1]);
		_nodeColor = hex2RGB(colorArray[2]);

		nodes = [];
		for (i in 0...numNodes) {
			nodes.push(createNode(i));
		}
	}

	function moveNodes(){
		for (i in 0...nodes.length) {
			var node = nodes[i];
			
			node.x += node.speed_x;
			node.y += node.speed_y;
			
			// Bounce off edges
			if (node.x < 50 || node.x > w - 50) {
				node.speed_x *= -1;
			}
			if (node.y < 50 || node.y > h - 50) {
				node.speed_y *= -1;
			}
		}
	}

	function drawConstellation(){
		ctx.clearRect(0, 0, w, h);
		ctx.backgroundObj(_bgColor);
		
		moveNodes();
		
		// Draw connections
		for (i in 0...nodes.length) {
			var n1 = nodes[i];
			
			for (j in (i+1)...nodes.length) {
				var n2 = nodes[j];
				var dist = distance(n1.x, n1.y, n2.x, n2.y);
				
				if (dist < maxDistance) {
					var alpha = 0.5 - (dist / maxDistance);
					ctx.lineColour(_lineColor.r, _lineColor.g, _lineColor.b, alpha);
					ctx.lineWidth = 1;
					ctx.line(n1.x, n1.y, n2.x, n2.y);
				}
			}
		}
		
		// Draw nodes
		for (i in 0...nodes.length) {
			var node = nodes[i];
			
			// Outer glow
			ctx.fillStyle = getColourObj(_nodeColor, 0.2);
			ctx.fillCircle(node.x, node.y, node.size * 3);
			
			// Main node
			ctx.fillStyle = getColourObj(_nodeColor, node.alpha);
			ctx.fillCircle(node.x, node.y, node.size);
		}
	}

	override function draw(){
		drawConstellation();
	}
}
