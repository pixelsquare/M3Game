package m3.main.tile;

import flambe.Component;
import flambe.Entity;
import flambe.display.FillSprite;
import flambe.Disposer;
import m3.pxlSq.Utils;
import flambe.display.Sprite;
import flambe.animation.AnimatedFloat;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Element extends Component
{
	public var alpha(default, null): AnimatedFloat;
	
	public var x(default, null): AnimatedFloat;
	public var y(default, null): AnimatedFloat;
	
	public var scaleX(default, null): AnimatedFloat;
	public var scaleY(default, null): AnimatedFloat;
	
	public var width(default, null): AnimatedFloat;
	public var height(default, null): AnimatedFloat;
	
	private var elementParent: Entity;
	private var elementEntity: Entity;
	private var elementDisposer: Disposer;
	
	public function new() {
		this.alpha = new AnimatedFloat(1);
		this.x = new AnimatedFloat(0.0);
		this.y = new AnimatedFloat(0.0);
		
		this.scaleX = new AnimatedFloat(1.0);
		this.scaleY = new AnimatedFloat(1.0);
		
		this.width = new AnimatedFloat(0.0);
		this.height = new AnimatedFloat(0.0);
	}
	
	public function SetAlpha(alpha: Float): Void {
		this.alpha._ = alpha;
	}
	
	public function SetXY(x: Float, y: Float): Void {
		this.x._ = x;
		this.y._  = y;
	}
	
	public function SetSize(width: Float, height: Float): Void {
		this.width._ = width;
		this.height._ = height;
	}
	
	public function SetScale(sclX: Float, sclY: Float): Void {
		this.scaleX._ = sclX;
		this.scaleY._ = sclY;
	}
	
	public function SetParent(parent: Entity): Void {
		this.elementParent = parent;
	}
	
	public function GetNaturalWidth(): Float {
		return this.width._;
	}
	
	public function GetNaturalHeight(): Float {
		return this.height._;
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
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		this.alpha.update(dt);
		this.x.update(dt);
		this.y.update(dt);
		this.scaleX.update(dt);
		this.scaleY.update(dt);
		this.width.update(dt);
		this.height.update(dt);
	}
	
	override public function dispose() {
		super.dispose();
		
		elementEntity.dispose();
	}
	
	public function PrintPos(): String {
		return this.x + " " + this.y;
	}
}