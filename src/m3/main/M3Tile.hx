package m3.main;

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
import m3.pxlSq.Utils;
import flambe.animation.Ease;
import m3.main.GameData;
import flambe.System;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Tile extends M3Element implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	public var fillCount(default, null): Int;
	public var isAnimating: Bool;
	
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
		tileSquare = new FillSprite(this.color, this.width, this.height);
		tileSquare.setXY(this.x._, this.y._);
		tileSquare.centerAnchor();
		elementEntity.add(tileSquare);
		
		//var pointerIsDown: Bool = false;
		//var startPoint: Point = new Point(0, 0);
		//var endPoint: Point = new Point(0, 0);
		//
		//System.pointer.down.connect(function(event: PointerEvent) {
			//startPoint = new Point(event.viewX - (System.stage.width / 2), (System.stage.height / 2) - event.viewY);
			//pointerIsDown = true;
		//});
		//
		//System.pointer.up.connect(function(event: PointerEvent) {
			//if (!pointerIsDown)
				//return;
				//
			//endPoint = new Point(event.viewX - (System.stage.width / 2), (System.stage.height / 2) - event.viewY);
			//
			//var direction: Point = new Point(
				//endPoint.x - startPoint.x,
				//endPoint.y - startPoint.y
			//);
			//
			//if (Math.abs(direction.x) > Math.abs(direction.y)) {
				//if (direction.x > 0) {
//
				//}
				//else {
					//
				//}
			//}
			//else {
				//if (direction.y > 0) {
					//
				//}
				//else {
					//
				//}
			//}
		//});
		
		tileSquare.pointerUp.connect(function(event: PointerEvent) {
			SwapTo(M3SwapDirection.Right);
			
			//if (isAnimating)
				//return;
		//
			//var m3Main: M3Main = elementParent.get(M3Main);
			//
			//var curBlock: M3Block = m3Main.gridBoard[idx][idy];
			//var rightBlock: M3Block = m3Main.gridBoard[idx + 1][idy];
			//
			//if (rightBlock == null || rightBlock.IsBlocked())
				//return;
				//
			//if (!rightBlock.IsBlockEmpty()) {
				//M3Utils.SwapTiles(curBlock, rightBlock, elementEntity, function() {
					//// If invalid move
					//M3Utils.SwapTiles(rightBlock, curBlock, elementEntity);
				//});
			//}
				
			//dispose();
			//
			//var m3Main: M3Main = elementParent.get(M3Main);
			//m3Main.GetTile(idx + 1, idy).dispose();
			//m3Main.GetTile(idx - 1, idy).dispose();
			
			//if (fillCount == 0) {
				//m3Main.SetTilesFillCount(1);
			//}
			//if (fillCount == 1) {
				//m3Main.SetTilesFillCount(0);
			//}
		});
	}
	
	public function SwapTo(swapDir: M3SwapDirection): Void {
		if (isAnimating)
			return;
			
		var m3Main: M3Main = elementParent.get(M3Main);
		var curBlock: M3Block = m3Main.gridBoard[idx][idy];
		var nextBlock: M3Block = M3Utils.GetBlockToSwap(this, m3Main, swapDir);
		M3Utils.SwapTiles(curBlock, nextBlock, elementEntity, function() {
			
			var blocks: Array<M3Block> = M3Utils.CheckHorizontal(this, m3Main);
			//if (blocks != null) {
				//for (block in blocks) {
					//Utils.ConsoleLog(block.PrintID());
				//}
			//}
			Utils.ConsoleLog(blocks.length + "");
			//if (blocks.length == 2) {
				//Utils.ConsoleLog("MATCH!");
				//return;
			//}
			// If invalid move
			M3Utils.SwapTiles(nextBlock, curBlock, elementEntity);
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
				new AnimateTo(this.y, nextTile.y._, 0.2),
				new CallFunction(function() {
					SetGridID(nextTile.idx, nextTile.idy);
					elementEntity.removeChild(new Entity().add(script));
					script.dispose();
					isAnimating = false;
				})
			]));
			elementEntity.addChild(new Entity().add(script));
			
			//this.y.animateTo(nextTile.y._, 0.2);
			//SetGridID(nextTile.idx, nextTile.idy);
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
						new AnimateTo(this.x, bottomRight.x._, 0.2),
						new AnimateTo(this.y, bottomRight.y._, 0.2)
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
						new AnimateTo(this.x, bottomLeft.x._, 0.2),
						new AnimateTo(this.y, bottomLeft.y._, 0.2)
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
	
	override public function SetXY(x:Float, y:Float): Void {
		super.SetXY(x, y);
		
		if (tileSquare == null)
			return;	
		
		tileSquare.setXY(this.x._, this.y._);
	}
	
	override public function SetSize(width:Float, height:Float): Void {
		super.SetSize(width, height);
		
		if (tileSquare == null)
			return;
			
		tileSquare.setSize(this.width, this.height);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		DrawTile();
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		tileSquare.setAlpha(this.alpha._);
		tileSquare.setXY(this.x._, this.y._);
		
		
		//UpdateDropPosition();
		//UpdateFillRight();
		//UpdateFillLeft();
		
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