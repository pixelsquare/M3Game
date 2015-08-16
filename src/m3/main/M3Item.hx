package m3.main;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.animation.AnimatedFloat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.System;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Item extends Component
{
	public var x(default, null): AnimatedFloat;
	public var y(default, null): AnimatedFloat;
	
	public var width(default, null): AnimatedFloat;
	public var height(default, null): AnimatedFloat;
	
	public var color: Int;
	
	public var spawner: M3Spawner;
	private var gridIndx: Int;
	
	private var gridContainer: M3GridContainer;
	
	private var itemEntity: Entity;
	public var itemTexture(default, null): FillSprite;
	
	public function new(color: Int, width: Float, height: Float, spawner: M3Spawner) {
		this.x = new AnimatedFloat(0);
		this.y = new AnimatedFloat(0);
		this.width = new AnimatedFloat(width);
		this.height = new AnimatedFloat(height);
		this.spawner = spawner;
		this.color = color;
		
		CreateItem();
		MoveDown();
	}
	
	public function CreateItem(): Void {
		itemEntity = new Entity();
		
		itemTexture = new FillSprite(this.color, this.width._, this.height._);
		itemTexture.centerAnchor();
		itemTexture.setXY(x._, y._);
		itemEntity.addChild(new Entity().add(itemTexture));
		
		itemTexture.alpha.animate(0, 1, 0.5);
	}
	
	public function MoveDown(): Void {
		if (spawner.spawnerGrids[gridIndx].item != null)
			return;
			
		if (gridIndx > 0) { 
			spawner.spawnerGrids[gridIndx - 1].SetItem(null);
		}
		spawner.spawnerGrids[gridIndx].SetItem(this);
		gridContainer = spawner.spawnerGrids[gridIndx];
		
		var gridPoint: Point = M3Board.GetGridXY(spawner.spawnerID, gridIndx);
		var script: Script = new Script();
		script.run(new Sequence([
			new AnimateTo(this.y, gridPoint.y, 0.5),
			new CallFunction(function() {
				gridIndx++;
				script.dispose();
				MoveDown();
			})
		]));
		itemEntity.add(script);
	}
	
	public function RemoveItem(): Void {
		gridContainer.SetItem(null);
		owner.removeChild(new Entity().add(this));
	}

	public function SetItemXY(x: Float, y: Float): Void {
		this.x._ = x;
		this.y._ = y;
		itemTexture.setXY(this.x._, this.y._);
	}
	
	public function SetItemSize(w: Float, h: Float): Void {
		this.width._ = w;
		this.height._ = h;
		itemTexture.width._ = this.width._;
		itemTexture.height._	= this.height._;
	}
	
	public function SetItemColor(color: Int): Void {
		this.color = color;
		itemTexture.color = this.color;
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
		owner.addChild(itemEntity);
	}

	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		x.update(dt);
		y.update(dt);
		width.update(dt);
		height.update(dt);
		
		//if(spawner.HasEmptySlot()) {
			//MoveDown();
		//}
		
		itemTexture.setXY(this.x._, this.y._);
		itemTexture.width._ = this.width._;
		itemTexture.height._	= this.height._;
		itemTexture.color = this.color;
	}
}