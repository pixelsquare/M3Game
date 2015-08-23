package m3.main;

/**
 * @author Anthony Ganzon
 */
interface IGrid 
{
	public var id(default, null): Int;
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	public function SetGridID(id: Int, idx: Int, idy: Int): Void;
	public function PrintID(): String;
}