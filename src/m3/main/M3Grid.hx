package m3.main;
import flambe.display.FillSprite;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Grid extends M3Element implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	private var color: Int;
	private var gridSquare: FillSprite;
	
	public function new(color: Int) {
		super();
		
		this.idx = 0;
		this.idy = 0;
		
		this.color = color;
	}
	
	public function DrawGrid(): Void {
		gridSquare = new FillSprite(this.color, this.width, this.height);
		gridSquare.setXY(this.x._, this.y._);
		gridSquare.centerAnchor();
		elementEntity.add(gridSquare);
	}
	
	public function ShowVisual(): Void {
		gridSquare.visible = true;
	}
	
	public function HideVisual(): Void {
		gridSquare.visible = false;
	}
	
	public function SetColor(color: Int): Void {
		this.color = color;
		
		if (gridSquare == null)
			return;
			
		gridSquare.color = this.color;
	}
	
	override public function SetXY(x:Float, y:Float): Void {
		super.SetXY(x, y);
		
		if (gridSquare == null)
			return;
			
		gridSquare.setXY(this.x._, this.y._);
	}
	
	override public function SetSize(width:Float, height:Float): Void {
		super.SetSize(width, height);
		
		if (gridSquare == null)
			return;
			
		gridSquare.setSize(this.width, this.height);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		DrawGrid();
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		gridSquare.setAlpha(this.alpha._);
		gridSquare.setXY(this.x._, this.y._);
	}
	
	override public function dispose() {
		super.dispose();
		
		elementParent.get(M3Main).gridBoard[idx][idy] = null;
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