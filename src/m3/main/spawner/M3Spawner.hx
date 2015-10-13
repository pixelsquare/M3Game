package m3.main.spawner;
import flambe.display.FillSprite;
import m3.main.grid.M3Block;
import m3.main.tile.M3Tile;
import m3.main.utils.IGrid;
import m3.main.utils.GameData;
import m3.pxlSq.Utils;
import m3.main.tile.M3Element;

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
		spawnerSquare = new FillSprite(0xFFFFFF, this.width._, this.height._);
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
			var tile: M3Tile = m3Main.CreateTile(this, firstBlock);
			tile.alpha.animate(0, 1, GameData.TILE_TWEEN_SPEED / 2);
			tile.y.animateTo(firstBlock.y._, GameData.TILE_TWEEN_SPEED);
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
			
		spawnerSquare.setSize(this.width._, this.height._);
	}
	
	override public function onAdded() {
		super.onAdded();
		
		Draw();
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if(spawnerSquare != null) {
			spawnerSquare.setAlpha(this.alpha._);
			spawnerSquare.setXY(this.x._, this.y._);
			spawnerSquare.setScaleXY(this.scaleX._, this.scaleY._);
			spawnerSquare.setSize(this.width._, this.height._);
		}
		
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