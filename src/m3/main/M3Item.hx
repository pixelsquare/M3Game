package m3.main;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.math.Point;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Item extends Component
{
	public var x(get, null): AnimatedFloat;
	public var y(get, null): AnimatedFloat;
	
	public var width(get, null): AnimatedFloat;
	public var height(get, null): AnimatedFloat;
	
	public var color: Int;
	
	private var itemEntity: Entity;
	private var itemTexture: FillSprite;
	
	public function new(color: Int, width: Float, height: Float) {
		this.x = new AnimatedFloat(0);
		this.y = new AnimatedFloat(0);
		this.width = new AnimatedFloat(width);
		this.height = new AnimatedFloat(height);
		this.color = color;
		
		CreateItem();
	}
	
	public function CreateItem(): Void {
		itemEntity = new Entity();
		
		itemTexture = new FillSprite(this.color, this.width._, this.height._);
		itemTexture.centerAnchor();
		itemTexture.setXY(x._, y._);
		itemEntity.addChild(new Entity().add(itemTexture));
	}

	public function SetItemXY(x: Float, y: Float): Void {
		this.x._ = x;
		this.y._ = y;
	}
	
	public function SetItemSize(w: Float, h: Float): Void {
		itemTexture.width._ = w;
		itemTexture.height._ = h;
	}
	
	public function get_x(): AnimatedFloat { 
		return itemTexture.x;
	}
	
	public function get_y(): AnimatedFloat {
		return itemTexture.y;
	}
	
	public function get_width(): AnimatedFloat {
		return itemTexture.width;
	}
	
	public function get_height(): AnimatedFloat {
		return itemTexture.height;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(itemEntity);
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
	}
	
	override public function dispose() 
	{
		super.dispose();
		itemEntity.dispose();
	}
	
}