package m3.main.tile.bomb;
import flambe.Entity;
import flambe.script.AnimateTo;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import m3.main.tile.bomb.BombType;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3AreaBomb extends M3TileBomb
{	
	private static inline var BLOAT_SIZE = 1.5;
	private static inline var BLOAT_SPEED = 0.2;
	
	public function new(color:Int) {
		super(color);
	}
	
	override public function GetBombType(): BombType {
		return BombType.AREA_BOMB;
	}
	
	override public function onAdded() {
		super.onAdded();
		
		var script: Script = new Script();
		script.run(new Repeat(new Sequence([
			new Parallel([
				new AnimateTo(this.scaleX, BLOAT_SIZE, BLOAT_SPEED),
				new AnimateTo(this.scaleY, BLOAT_SIZE, BLOAT_SPEED)
			]),
			new Parallel([
				new AnimateTo(this.scaleX, 0.0, BLOAT_SPEED),
				new AnimateTo(this.scaleY, 0.0, BLOAT_SPEED)
			])
		])));
		elementEntity.addChild(new Entity().add(script));
	}
}