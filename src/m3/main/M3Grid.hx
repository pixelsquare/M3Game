package m3.main;
import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.math.Point;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Grid extends Component
{
	public var x(get, null): AnimatedFloat;
	public var y(get, null): AnimatedFloat;
	
	public var width(get, null): AnimatedFloat;
	public var height(get, null): AnimatedFloat;
	
	public var color: Int;
	
	private var gridEntity: Entity;
	private var gridTexture: FillSprite;
	
	public function new(color: Int, width: Float, height: Float) {	
		this.x = new AnimatedFloat(0);
		this.y = new AnimatedFloat(0);
		this.width = new AnimatedFloat(width);
		this.height = new AnimatedFloat(height);
		this.color = color;
		
		CreateGrid();
	}
	
	public function CreateGrid(): Void {
		gridEntity = new Entity();
		
		gridTexture = new FillSprite(this.color, this.width._, this.height._);
		gridTexture.centerAnchor();
		gridTexture.setXY(x._, y._);
		gridEntity.addChild(new Entity().add(gridTexture));
	}
	
	public function SetGridXY(x: Float, y: Float): Void {
		this.x._ = x;
		this.y._ = y;
	}
	
	public function SetGridSize(w: Float, h: Float): Void {
		gridTexture.width._ = w;
		gridTexture.height._ = h;
	}
	
	public function get_x(): AnimatedFloat { 
		return gridTexture.x;
	}
	
	public function get_y(): AnimatedFloat {
		return gridTexture.y;
	}
	
	public function get_width(): AnimatedFloat {
		return gridTexture.width;
	}
	
	public function get_height(): AnimatedFloat {
		return gridTexture.height;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(gridEntity);
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
	}
	
	override public function dispose() 
	{
		super.dispose();
		gridEntity.dispose();
	}
}