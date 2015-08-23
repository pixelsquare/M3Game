package m3.main;

import flambe.display.FillSprite;
import flambe.input.PointerEvent;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Tile extends M3Element implements IGrid
{
	public var id(default, null): Int;
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	private var color: Int;

	private var tileSquare: FillSprite;
	
	public function new(color: Int ) {
		super();
		
		this.id = 0;
		this.idx = 0;
		this.idy = 0;
		
		this.color = color;
	}
	
	public function DrawTile(): Void {
		tileSquare = new FillSprite(this.color, this.width, this.height);
		tileSquare.setXY(this.x, this.y);
		tileSquare.centerAnchor();
		elementEntity.add(tileSquare);
		
		tileSquare.pointerUp.connect(function(event: PointerEvent) {
			dispose();
		});
	}
	
	public function UpdatePosition(): Void {
		if ((idy + 1) > 9)
			return;
		
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var nextTile: M3Grid = m3Main.gridBoard[idx][idy + 1];
		if (nextTile == null)
			return;
			
		if (nextTile.IsGridEmpty()) {
			//Utils.ConsoleLog(PrintID() + " | " + nextTile.PrintID());
			elementParent.get(M3Main).gridList[id].SetTile(null);
			elementParent.get(M3Main).gridBoard[idx][idy].SetTile(null);
			
			SetXY(nextTile.x, nextTile.y);
			SetGridID(nextTile.id, nextTile.idx, nextTile.idy);
			
			elementParent.get(M3Main).gridList[nextTile.id].SetTile(this);
			elementParent.get(M3Main).gridBoard[idx][idy + 1].SetTile(this);
			//Utils.ConsoleLog(PrintID());
		}
	}
	
	override public function SetXY(x:Float, y:Float): Void {
		super.SetXY(x, y);
		
		if (tileSquare == null)
			return;	
		
		tileSquare.setXY(this.x, this.y);
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
		
		UpdatePosition();
	}

	override public function dispose() {
		super.dispose();
		elementParent.get(M3Main).tileList[id] = null;
		elementParent.get(M3Main).gridList[id].SetTile(null);
		elementParent.get(M3Main).gridBoard[idx][idy].SetTile(null);
	}
	
	/* INTERFACE m3.main.IGrid */
	
	public function SetGridID(id: Int, idx:Int, idy:Int): Void {
		this.id = id;
		this.idx = idx;
		this.idy = idy;
	}	
	
	public function PrintID(): String {
		return this.id + " " + this.idx + " " + this.idy;
	}
}