package m3.main;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Block extends M3Grid
{
	private var blockTile: M3Tile;
	private var isBlocked: Bool;
	
	public function new(color:Int) {
		super(color);
		this.isBlocked = false;
	}
	
	public function SetBlockTile(tile: M3Tile): Void {
		if (isBlocked)
			return;
		
		blockTile = tile;
	}
	
	public function SetBlocked(blocked: Bool = true): Void {
		isBlocked = blocked;
		
		if (!isBlocked) {
			ShowVisual();
		}
		else {
			HideVisual();
		}
	}
	
	public function IsBlockEmpty(): Bool {
		return blockTile == null;
	}
	
	public function GetTile(): M3Tile {
		return blockTile;
	}
	
	public function IsBlocked(): Bool {
		return isBlocked;
	}
}