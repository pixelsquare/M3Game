package m3.main;
import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.math.Point;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Grid extends Component
{
	public var x(default, null): AnimatedFloat;
	public var y(default, null): AnimatedFloat;
	
	public var width(default, null): AnimatedFloat;
	public var height(default, null): AnimatedFloat;
	
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
		gridTexture.setXY(this.x._, this.y._);
	}
	
	public function SetGridSize(w: Float, h: Float): Void {
		this.width._ = w;
		this.height._ = h;
		gridTexture.width._ = this.width._;
		gridTexture.height._	= this.height._;
	}
	
	public function SetGridColor(color: Int): Void {
		this.color = color;
		gridTexture.color = this.color;
	}
	
	public function GetNaturalWidth(): Float {
		return width._;
	}
	
	public function getNaturalHeight(): Float {
		return height._;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(gridEntity);
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		x.update(dt);
		y.update(dt);
		width.update(dt);
		height.update(dt);
		
		gridTexture.setXY(this.x._, this.y._);
		gridTexture.width._ = this.width._;
		gridTexture.height._	= this.height._;
		gridTexture.color = this.color;
	}
}