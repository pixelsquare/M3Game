package m3.main;

import flambe.display.FillSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Script;
import flambe.script.Sequence;
import m3.pxlSq.Utils;
import flambe.animation.Ease;
import m3.main.GameData;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Tile extends M3Element implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	private var color: Int;

	private var tileSquare: FillSprite;
	private var fillCount: Int;
	
	public function new(color: Int ) {
		super();
		
		this.idx = 0;
		this.idy = 0;
		
		this.color = color;
		this.fillCount = 0;
	}
	
	public function DrawTile(): Void {
		tileSquare = new FillSprite(this.color, this.width, this.height);
		tileSquare.setXY(this.x._, this.y._);
		tileSquare.centerAnchor();
		elementEntity.add(tileSquare);
		
		tileSquare.pointerUp.connect(function(event: PointerEvent) {
			dispose();
		});
	}
	
	public function UpdateDropPosition(): Void {
		if ((idy + 1) >= GameData.GRID_COLS) 
			return;
		
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var nextTile: M3Block = m3Main.gridBoard[idx][idy + 1];
		if (nextTile == null || nextTile.IsBlocked())
			return;
			
		if (nextTile.IsBlockEmpty()) {
			elementParent.get(M3Main).gridBoard[idx][idy].SetBlockTile(null);
			elementParent.get(M3Main).gridBoard[idx][idy + 1].SetBlockTile(this);
			this.y.animateTo(nextTile.y._, 0.5);
			SetGridID(nextTile.idx, nextTile.idy);
		}
	}
	
	public function UpdateFillRight(): Void {
		if ((idx + 1) >= GameData.GRID_ROWS || (idy + 1) >= GameData.GRID_COLS)
			return;
			
		if (fillCount == 1)
			return;
		
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var rightTile: M3Block = m3Main.gridBoard[idx + 1][idy];
		var bottomRightTile: M3Block = m3Main.gridBoard[idx + 1][idy + 1];
		if (bottomRightTile == null || bottomRightTile.IsBlocked())
			return;
		
		if (bottomRightTile.IsBlockEmpty() && rightTile.IsBlocked()) {
			elementParent.get(M3Main).gridBoard[idx][idy].SetBlockTile(null);
			elementParent.get(M3Main).gridBoard[idx + 1][idy + 1].SetBlockTile(this);
			this.x.animateTo(bottomRightTile.x._, 0.5);
			this.y.animateTo(bottomRightTile.y._, 0.5);
			SetGridID(bottomRightTile.idx, bottomRightTile.idy);
			m3Main.SetTilesFillCount(1);
		}
	}
	
	public function UpdateFillLeft(): Void {
		if ((idx - 1) < 0 || (idy - 1) < 0) {
			return;
		}

		if (fillCount == 0)
			return;
			
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var leftTile: M3Block = m3Main.gridBoard[idx - 1][idy];
		var bottomLeftTile: M3Block = m3Main.gridBoard[idx - 1][idy + 1];
		if (bottomLeftTile == null || bottomLeftTile.IsBlocked())
			return;
			
		if (bottomLeftTile.IsBlockEmpty() && leftTile.IsBlocked()) {
			elementParent.get(M3Main).gridBoard[idx][idy].SetBlockTile(null);
			elementParent.get(M3Main).gridBoard[idx - 1][idy + 1].SetBlockTile(this);
			this.x.animateTo(bottomLeftTile.x._, 0.5);
			this.y.animateTo(bottomLeftTile.y._, 0.5);
			SetGridID(bottomLeftTile.idx, bottomLeftTile.idy);
			m3Main.SetTilesFillCount(0);
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
		UpdateDropPosition();
		UpdateFillRight();
		UpdateFillLeft();
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