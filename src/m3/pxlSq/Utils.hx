package m3.pxlSq;
import flambe.Entity;

#if flash
import flash.external.ExternalInterface;
#end

/**
 * ...
 * @author Anthony Ganzon
 * Console logger for debugging purposes.
 * NOTE: Works only with flash build
 */
class Utils
{

	public static function ConsoleLog(str: Dynamic): Void {
		#if flash
		ExternalInterface.call("console.log", str);
		#end
	}
	
	public static function DebugEntity(entity: Entity): Void {
		if (entity == null) {
			ConsoleLog("1 Entity is Null!");
		}
		
		if (entity.parent == null) {
			ConsoleLog("2 Parent is Null!");
		}
		
		if (entity.firstChild == null) {
			ConsoleLog("3 First Child is null!");
		}
		
		if (entity.next == null) {
			ConsoleLog("4 Next is null!");
		}
		
		if (entity.firstComponent == null) {
			ConsoleLog("5 First Component is null!");
		}
	}
	
	public static function GetSpritesRecursively(root: Entity, result: Array<Entity>): Void {
		var child: Entity = root.firstChild;
		while (child != null) {
			var next = child.next;
			result.push(child);
			GetSpritesRecursively(child, result);
			child = next;
		}
	}
}
