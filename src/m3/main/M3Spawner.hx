package m3.main;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.animation.AnimatedFloat;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;

import m3.main.M3Grid;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Spawner extends Component
{
	public var x(default, null): AnimatedFloat;
	public var y(default, null): AnimatedFloat;
	
	public var width(default, null): AnimatedFloat;
	public var height(default, null): AnimatedFloat;
	
	public var color: Int;
	
	private var spawnerEntity: Entity;
	public var spawnerGrids(default, null): Array<M3GridContainer>;
	
	private var spawnerTexture: FillSprite;
	
	public var spawnerID(default, null): Int;
	
	private var spawnCount: Int;
	
	public function new(id: Int, grids: Array<M3GridContainer>) {
		this.spawnerID = id;
		this.spawnerGrids = grids;
		
		this.x = new AnimatedFloat(0);
		this.y = new AnimatedFloat(0);
		this.width = new AnimatedFloat(10);
		this.height = new AnimatedFloat(10);
		this.color = 0x004488;
		
		CreateVisuals();
	}
	
	public function CreateVisuals(): Void {
		spawnerEntity = new Entity();
		
		spawnerTexture = new FillSprite(this.color, this.width._, this.height._);
		spawnerTexture.centerAnchor();
		spawnerTexture.setXY(x._, y._);
		spawnerEntity.addChild(new Entity().add(spawnerTexture));
		
		FillSpawners();
	}
	
	public function FillSpawners(): Void {
		for (grid in spawnerGrids) {
			if (grid.item != null)
				continue;
			
			spawnCount++;
		}
		
	}
	
	public function SpawnItems(): Void {
		if (spawnerGrids[0].item != null) return;
		
		var gridPoint: Point = M3Board.GetGridXY(spawnerID, 0);
		var item: M3Item = new M3Item(0x448800, 20, 20, this);
		item.SetItemXY(gridPoint.x, gridPoint.y  - (M3Board.GetGrid(spawnerID, 0).height._));
		spawnerEntity.addChild(new Entity().add(item));
		
		item.itemTexture.pointerDown.connect(function(event: PointerEvent) {
			Utils.ConsoleLog("QWE");
			item.RemoveItem();
			//spawnerEntity.removeChild(new Entity().add(item));
		});
	}
	
	public function HasEmptySlot(): Bool {
		var i: Int = 0;
		for (grid in spawnerGrids) {
			if (grid.item != null)
				continue;
			
			i++;
		}
		
		return i > 0;
	}

	public function SetSpawnerXY(x: Float, y: Float): Void {
		this.x._ = x; 
		this.y._ = y;
		spawnerTexture.setXY(this.x._, this.y._);
	}
	
	public function SetSpawnerSize(w: Float, h: Float): Void {
		this.width._ = w;
		this.height._ = h;
		spawnerTexture.width._ = this.width._;
		spawnerTexture.height._	= this.height._;
	}
	
	public function SetSpawnerColor(color: Int): Void {
		this.color = color;
		spawnerTexture.color = this.color;
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
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		x.update(dt);
		y.update(dt);
		width.update(dt);
		height.update(dt);
		
		SpawnItems();
		
		spawnerTexture.setXY(this.x._, this.y._);
		spawnerTexture.width._ = this.width._;
		spawnerTexture.height._	= this.height._;
		spawnerTexture.color = this.color;
	}
}