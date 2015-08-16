package m3.main;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.math.Point;
import flambe.animation.AnimatedFloat;

import m3.main.M3Grid;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Spawner extends Component
{
	public var x(get, null): AnimatedFloat;
	public var y(get, null): AnimatedFloat;
	
	public var width(get, null): AnimatedFloat;
	public var height(get, null): AnimatedFloat;
	
	public var color: Int;
	
	private var spawnerEntity: Entity;
	private var spawnerGrids: Array<M3Grid>;
	
	private var spawnerTexture: FillSprite;
	
	public function new(grids: Array<M3Grid>) {
		spawnerGrids = grids;
		
		this.x = new AnimatedFloat(0);
		this.y = new AnimatedFloat(0);
		this.width = new AnimatedFloat(10);
		this.height = new AnimatedFloat(10);
		this.color = 0xFFFFFF;
		
		CreateVisuals();
	}
	
	public function CreateVisuals(): Void {
		spawnerEntity = new Entity();
		
		spawnerTexture = new FillSprite(this.color, this.width._, this.height._);
		spawnerTexture.setXY(x._, y._);
		spawnerEntity.addChild(new Entity().add(spawnerTexture));
	}
	
	public function SetSpawnerXY(x: Float, y: Float): Void {
		this.x._ = x; 
		this.y._ = y;
	}
	
	public function SetSpawnerSize(w: Float, h: Float): Void {
		this.width._ = w;
		this.height._ = h;
	}
	
	public function get_x(): AnimatedFloat { 
		return spawnerTexture.x;
	}
	
	public function get_y(): AnimatedFloat {
		return spawnerTexture.y;
	}
	
	public function get_width(): AnimatedFloat {
		return spawnerTexture.width;
	}
	
	public function get_height(): AnimatedFloat {
		return spawnerTexture.height;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(spawnerEntity);
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
	}
	
	override public function dispose() 
	{
		super.dispose();
		spawnerEntity.dispose();
	}
}