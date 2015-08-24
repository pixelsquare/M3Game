package m3.main;
import flambe.display.FillSprite;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Spawner extends M3Element implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	private var spawnerSquare: FillSprite;
	
	public function new() {
		super();
		
		this.idx = 0;
		this.idy = 0;		
	}
	
	public function Draw(): Void {
		spawnerSquare = new FillSprite(0xFFFFFF, this.width, this.height);
		spawnerSquare.setXY(this.x._, this.y._);
		spawnerSquare.centerAnchor();
		elementEntity.add(spawnerSquare);
	}
	
	public function SpawnTiles(): Void {
		var m3Main: M3Main = elementParent.get(M3Main);
		
		var firstBlock: M3Block = m3Main.gridBoard[idx][idy];
		if (firstBlock == null || firstBlock.IsBlocked())
			return;
			
		if (firstBlock.IsBlockEmpty()) {
			//Utils.ConsoleLog(firstBlock.PrintID());
			m3Main.CreateTile(this, firstBlock);
		}
	}
	
	public function HideVisual(): Void {
		spawnerSquare.visible = false;
	}
	
	override public function SetXY(x:Float, y:Float): Void {
		super.SetXY(x, y);
		
		if (spawnerSquare == null)
			return;
			
		spawnerSquare.setXY(this.x._, this.y._);
	}
	
	override public function SetSize(width:Float, height:Float): Void {
		super.SetSize(width, height);
		
		if (spawnerSquare == null)
			return;
			
		spawnerSquare.setSize(this.width, this.height);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		Draw();
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		spawnerSquare.setAlpha(this.alpha._);
		spawnerSquare.setXY(this.x._, this.y._);
		SpawnTiles();
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