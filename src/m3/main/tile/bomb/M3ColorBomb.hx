package m3.main.tile.bomb;
import m3.main.tile.bomb.BombType;
import flambe.Entity;
import flambe.script.AnimateTo;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import m3.main.tile.bomb.BombType;
import m3.pxlSq.Utils;
import m3.main.utils.M3Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3ColorBomb extends M3TileBomb
{	
	private static inline var BLOAT_SIZE = 1.1;
	private static inline var BLOAT_SPEED = 0.2;
	
	public function new(color:Int) {
		super(color);
	}
	
	override public function GetBombType(): BombType {
		return BombType.COLOR_BOMB;
	}
	
	override public function onAdded() {
		super.onAdded();
		
		//tileSquare.color
		//var script: Script = new Script();
		//script.run(new Repeat(new Sequence([
			//new Parallel([
				//new AnimateTo(this.scaleX, 0.5, BLOAT_SPEED),
				//new AnimateTo(this.scaleY, 1.5, BLOAT_SPEED)
			//]),
			//new Parallel([
				//new AnimateTo(this.scaleX, 1.0, BLOAT_SPEED),
				//new AnimateTo(this.scaleY, 1.0, BLOAT_SPEED)
			//])
		//])));
		//elementEntity.addChild(new Entity().add(script));
	}	
	
	var time: Float = 0.0;
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		time += dt * 0.01;
		if (tileSquare != null) {
			tileSquare.color = Std.int(M3Utils.Lerp(0xFFFFFF, 0x202020, time));
		}
	}
}