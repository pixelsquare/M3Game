package m3.main;

import flambe.Component;
import m3.main.M3Grid;
import m3.main.M3Item;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3GridContainer extends Component
{

	public var grid(default, null): M3Grid;
	public var item(default, null): M3Item;
	
	public function new(grid: M3Grid, item: M3Item) {
		this.grid = grid;
		this.item = item;
	}
	
	public function SetGrid(grid: M3Grid): Void {
		this.grid = grid;
	}
	
	public function SetItem(item: M3Item): Void {
		this.item = item;
	}
}