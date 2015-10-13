package m3.main.tile;

import flambe.display.FillSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import haxe.Timer;
import m3.main.grid.M3Block;
import m3.main.utils.IGrid;
import m3.main.utils.M3SwapDirection;
import m3.main.utils.M3Utils;
import m3.pxlSq.Utils;
import flambe.animation.Ease;
import m3.main.utils.GameData;
import flambe.System;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Tile extends M3TileTouch implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	public var fillCount(default, null): Int;
	
	public var isAnimating: Bool;
	public var isKinematic: Bool;
	
	public var data(default, set): M3TileData;
	public function set_data(newData: M3TileData) {
		color = newData.TileColor;
		return data = newData;
	}
	
	private var color: Int;

	private var tileSquare: FillSprite;
	
	public function new(color: Int ) {
		super();
		
		this.idx = 0;
		this.idy = 0;
		this.data = new M3TileData();
		
		this.color = color;
		this.fillCount = 0;
	}
	
	public function DrawTile(): Void {
		tileSquare = new FillSprite(this.color, this.width._, this.height._);
		tileSquare.setXY(this.x._, this.y._);
		tileSquare.centerAnchor();
		elementEntity.add(tileSquare);
	}
	
	public function Swap(swapDir: M3SwapDirection): Void {
		if (isAnimating)
			return;
			
		var m3Main: M3Main = elementParent.get(M3Main);
		var curBlock: M3Block = m3Main.gridBoard[idx][idy];
		var nextBlock: M3Block = M3Utils.GetBlockToSwap(this, m3Main, swapDir);
		M3Utils.SwapTiles(curBlock, nextBlock, elementEntity, GameData.TILE_TWEEN_SPEED, function() {
			m3Main.SetStageDirty();
			M3Utils.SwapTiles(nextBlock, curBlock, elementEntity, GameData.TILE_TWEEN_SPEED);
		});
	}
	
	public function UpdateDropPosition(): Void {
		if ((idy + 1) >= GameData.GRID_COLS) 
			return;
			
		if (isAnimating)
			return;
		
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var nextTile: M3Block = m3Main.gridBoard[idx][idy + 1];
		if (nextTile == null || nextTile.IsBlocked())
			return;
			
		if (nextTile.IsBlockEmpty()) {
			elementParent.get(M3Main).gridBoard[idx][idy].SetBlockTile(null);
			elementParent.get(M3Main).gridBoard[idx][idy + 1].SetBlockTile(this);	
			isAnimating = true;
			
			var script: Script = new Script();
			script.run(new Sequence([
				new AnimateTo(this.y, nextTile.y._, GameData.TILE_TWEEN_SPEED),
				new CallFunction(function() {
					SetGridID(nextTile.idx, nextTile.idy);
					elementEntity.removeChild(new Entity().add(script));
					script.dispose();
					isAnimating = false;
				})
			]));
			elementEntity.addChild(new Entity().add(script));
		}
	}
	
	public function UpdateFillRight(): Void {
		if ((idx + 1) >= GameData.GRID_ROWS || (idy + 1) >= GameData.GRID_COLS)
			return;
			
		if (isAnimating || fillCount == 1)
			return;
		
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var rightBlock: M3Block = m3Main.gridBoard[idx + 1][idy];
		var bottomBlock: M3Block = m3Main.gridBoard[idx][M3Utils.GetBottomTileIndx(m3Main, this) - 1];
		
		if (rightBlock == null || bottomBlock == null)
			return;
			
		if (rightBlock.IsBlocked() && !bottomBlock.IsBlockEmpty()) {
			var bottomRight: M3Block = m3Main.gridBoard[idx + 1][idy + 1];

			if (bottomRight == null)
				return;
				
			if (bottomRight.IsBlockEmpty() && !bottomRight.IsBlocked()) {
				elementParent.get(M3Main).gridBoard[idx][idy].SetBlockTile(null);
				elementParent.get(M3Main).gridBoard[idx + 1][idy + 1].SetBlockTile(this);
				isAnimating = true;
				
				var script: Script = new Script();
				script.run(new Sequence([
					new Parallel([
						new AnimateTo(this.x, bottomRight.x._, GameData.TILE_TWEEN_SPEED),
						new AnimateTo(this.y, bottomRight.y._, GameData.TILE_TWEEN_SPEED)
					]),
					new CallFunction(function() {
						SetGridID(bottomRight.idx, bottomRight.idy);
						elementEntity.removeChild(new Entity().add(script));
						script.dispose();
						m3Main.SetTilesFillCount(1);
						isAnimating = false;
					})
				]));
				elementEntity.addChild(new Entity().add(script));
			}
		}	
	}
	
	public function UpdateFillLeft(): Void {
		if ((idx - 1) < 0 || (idy - 1) < 0)
			return;
			
		if (isAnimating || fillCount == 0)
			return;
		
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var leftBlock: M3Block = m3Main.gridBoard[idx - 1][idy];
		var bottomBlock: M3Block = m3Main.gridBoard[idx][M3Utils.GetBottomTileIndx(m3Main, this) - 1];
		
		if (leftBlock == null || bottomBlock == null)
			return;
			
		if (leftBlock.IsBlocked() && !bottomBlock.IsBlockEmpty()) {
			var bottomLeft: M3Block = m3Main.gridBoard[idx - 1][idy + 1];

			if (bottomLeft == null)
				return;
				
			if (bottomLeft.IsBlockEmpty() && !bottomLeft.IsBlocked()) {
				elementParent.get(M3Main).gridBoard[idx][idy].SetBlockTile(null);
				elementParent.get(M3Main).gridBoard[idx - 1][idy + 1].SetBlockTile(this);
				isAnimating = true;
				
				var script: Script = new Script();
				script.run(new Sequence([
					new Parallel([
						new AnimateTo(this.x, bottomLeft.x._, GameData.TILE_TWEEN_SPEED),
						new AnimateTo(this.y, bottomLeft.y._, GameData.TILE_TWEEN_SPEED)
					]),
					new CallFunction(function() {
						SetGridID(bottomLeft.idx, bottomLeft.idy);
						elementEntity.removeChild(new Entity().add(script));
						script.dispose();
						m3Main.SetTilesFillCount(0);
						isAnimating = false;
					})
				]));
				elementEntity.addChild(new Entity().add(script));
			}
		}	
	}
	
	public function SetFillCount(count: Int): Void {
		this.fillCount = count;
	}
	
	public function GetTileType(): TileType {
		return TileType.CUBE;
	}
	
	override public function SetXY(x:Float, y:Float): Void {
		super.SetXY(x, y);
		
		if (tileSquare == null)
			return;	
		
		tileSquare.setXY(this.x._, this.y._);
		tileSquare.setScaleXY(this.scaleX._, this.scaleY._);
	}
	
	override public function SetSize(width:Float, height:Float): Void {
		super.SetSize(width, height);
		
		if (tileSquare == null)
			return;
			
		tileSquare.setSize(this.width._, this.height._);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		DrawTile();
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if(tileSquare != null) {
			tileSquare.setAlpha(this.alpha._);
			tileSquare.setXY(this.x._, this.y._);
			tileSquare.setScaleXY(this.scaleX._, this.scaleY._);
			tileSquare.setSize(this.width._, this.height._);
		}
		
		if(!isKinematic) {
			UpdateDropPosition();
			UpdateFillRight();
			UpdateFillLeft();
		}
	}

	override public function dispose() {
		super.dispose();
		elementParent.get(M3Main).RemoveTile(this);
	}
	
	/* INTERFACE m3.main.IGrid */
	
	public function SetGridID(idx:Int, idy:Int): Void {
		this.idx = idx;
		this.idy = idy;
	}
	
	public function PrintID(): String {
		return "ID(" + this.idx + "," + this.idy + ")";
	}
}