package m3.main.tile.bomb;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import m3.main.tile.bomb.BombType;
import m3.main.tile.M3Tile;
import m3.main.tile.TileType;
import m3.core.GameManager;
import m3.name.AssetName;
import m3.pxlSq.Utils;
import m3.main.utils.M3Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3TileBomb extends M3Tile
{
	private var bombTexture: Texture;
	private var bombImage: ImageSprite;
	
	public function new(color:Int) {
		super(color);
	}
	
	public function SetBombTexture(tex: Texture): Void {
		bombTexture = tex;
	}
	
	//override public function DrawTile():Void {
		//bombImage = new ImageSprite(GameManager.current.GetGameData().gameAsset.getTexture(AssetName.ASSET_CUBE_20));
		//bombImage.setXY(this.x._, this.y._);
		//bombImage.setScaleXY(this.scaleX._, this.scaleY._);
		//bombImage.centerAnchor();
		//elementEntity.add(bombImage);
	//}
	
	public function GetBombType(): BombType {
		return BombType.AREA_BOMB;
	}
	
	override public function GetTileType(): TileType {
		return TileType.BOMB;
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		if (bombImage != null) {
			bombImage.setAlpha(this.alpha._);
			bombImage.setXY(this.x._, this.y._);
			bombImage.setScaleXY(this.scaleX._, this.scaleY._);
		}
	}
}