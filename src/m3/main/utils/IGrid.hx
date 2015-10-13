package m3.main.utils;

/**
 * @author Anthony Ganzon
 */
interface IGrid 
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	public function SetGridID(idx: Int, idy: Int): Void;
	public function PrintID(): String;
}