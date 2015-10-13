package m3.main.tile;
import flambe.display.Sprite;
import flambe.input.PointerEvent;
import m3.main.tile.M3Tile;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3TileTouch extends M3Element
{
	public function new() {
		super();
	}
	
	override public function onStart() {
		super.onStart();
		
		var m3Main: M3Main = elementParent.get(M3Main);
		var sprite: Sprite = elementEntity.get(Sprite);
		if (sprite != null) {
			sprite.pointerIn.connect(function(event: PointerEvent) {
				m3Main.onTilePointerIn.emit(Std.instance(this, M3Tile));
			});
			
			sprite.pointerOut.connect(function(event: PointerEvent) {
				m3Main.onTilePointerIn.emit(null);
			});
		}
	}
}