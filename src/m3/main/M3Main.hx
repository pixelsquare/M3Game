package m3.main;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.math.Rectangle;
import flambe.script.AnimateTo;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.script.Action;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Main
{
	private var m3Entity: Entity;
	private var grids: Array<Array<M3Grid>>;
	private var gridSprite: Sprite;
	
	//private var test: FillSprite;
	
	private static inline var GRID_SIZE: Int = 30;
	private static inline var GRID_ROWS: Int = 9;
	private static inline var GRID_COLUMNS: Int = 9;
	private static inline var GRID_DIST = 1.1;

	public function new() {	}
	
	public function Init(): Entity {
		m3Entity = new Entity();
		
		var board: M3Board = new M3Board(GRID_SIZE, GRID_ROWS, GRID_COLUMNS);
		m3Entity.addChild(new Entity().add(board));
		
		//for (ii in 0...board.boardGrids.length) {
			//for (jj in 0...board.boardGrids[ii].length) {
				//Utils.ConsoleLog(board.boardGrids[ii][jj].GetGridXY().x + " " + board.boardGrids[ii][jj].GetGridXY().y);
			//}
		//}

		//var item: M3Item = new M3Item();
		//item.SetItemSize(20, 20);
		//item.SetItemColor(0xEACABB);
		//item.SetItemXY(board.GetGridXY(1, 5).x, board.GetGridXY(1, 5).y);	
		//m3Entity.addChild(new Entity().add(item));
		
		return m3Entity;
	}
}