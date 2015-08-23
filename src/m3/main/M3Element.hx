package m3.main;

import flambe.Component;
import flambe.Entity;
import flambe.display.FillSprite;
import flambe.Disposer;
import m3.pxlSq.Utils;
import flambe.display.Sprite;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Element extends Component
{
	public var x(default, null): Float;
	public var y(default, null): Float;
	
	public var width(default, null): Float;
	public var height(default, null): Float;
	
	private var elementParent: Entity;
	private var elementEntity: Entity;
	private var elementDisposer: Disposer;
	
	public function new() {
		this.x = 0;
		this.y = 0;
		
		this.width = 0;
		this.height = 0;
	}
	
	public function SetXY(x: Float, y: Float): Void {
		this.x = x;
		this.y = y;
	}
	
	public function SetSize(width: Float, height: Float): Void {
		this.width = width;
		this.height = height;
	}
	
	public function SetParent(parent: Entity): Void {
		this.elementParent = parent;
	}
	
	override public function onAdded() {
		super.onAdded();
	
		owner.addChild(elementEntity = new Entity());
		
		elementDisposer = elementEntity.get(Disposer);
		if (elementDisposer == null) {
			elementEntity.add(elementDisposer = new Disposer());
		}
		
		//Utils.ConsoleLog(elementParent.has(M3Main) + "");
		//Utils.ConsoleLog(owner.toString());
	}
	
	override public function dispose() {
		super.dispose();
		
		elementEntity.dispose();
	}
	
	public function PrintPos(): String {
		return this.x + " " + this.y;
	}
}