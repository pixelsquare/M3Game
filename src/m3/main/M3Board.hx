package m3.main;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.display.Sprite;
import flambe.System;

import m3.main.M3Grid;
import m3.pxlSq.Utils;
import m3.main.M3GridContainer;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Board extends Component
{
	public var boardGrids(default, null): Array<Array<M3Grid>>;
	public var boardEntity(default, null): Entity;
	public var boardSpawners(default, null): Array<M3Spawner>;
	
	private var gridSize: Int;
	private var gridRows: Int;
	private var gridColumns: Int;
	
	private var gridSprite: Sprite;
	private var gridRect: Rectangle;
	
	public static var current: M3Board;
	
	private static inline var GRID_DIST = 1.1;
	
	public function new(size: Int, rows: Int, cols: Int) {
		gridSize = size;
		gridRows = rows;
		gridColumns = cols;
		
		current = this;
		
		CreateGridBoard();
		CreateSpawners();
	}
	
	public function CreateGridBoard(): Void {
		boardEntity = new Entity();
		
		var boardBG: FillSprite = new FillSprite(0xBFB8AF, 0, 0);
		boardEntity.addChild(new Entity().add(boardBG));
		
		var gridEntity: Entity = new Entity();
		boardGrids = new Array<Array<M3Grid>>();

		var x: Int = 0;
		while (x < gridRows) {
			var tilesArray: Array<M3Grid> = new Array<M3Grid>();
			var y: Int = 0;
			while (y < gridColumns) {
				var tile: M3Grid = new M3Grid(0xFFFFFF, gridSize, gridSize);
				tile.SetGridXY(
					x * tile.width._ * GRID_DIST,
					y * tile.height._ * GRID_DIST
				);
				gridEntity.addChild(new Entity().add(tile));
				
				tilesArray.push(tile);
				y++;
			}
			
			boardGrids.push(tilesArray);
			x++;
		}

		var i = 1;
		for (ii in 0...boardGrids.length) {
			for (grid in boardGrids[ii]) {
				grid.SetGridColor((i % 2 == 0) ? 0x202020 : 0xFFFFFF);
				i++;
			}
		}
		
		gridRect = Sprite.getBounds(gridEntity);
		gridSprite = new Sprite();
		gridSprite.setXY(
			(System.stage.width / 2) - (gridRect.x + (gridRect.width / 2)), 
			(System.stage.height / 2) - (gridRect.y + (gridRect.height / 2))
		);
		
		boardEntity.addChild(gridEntity.add(gridSprite));
	
		boardBG.width._ = gridRect.width + (gridSize * GRID_DIST) / 2;
		boardBG.height._ = gridRect.height + (gridSize * GRID_DIST) / 2;
		boardBG.setXY(
			gridRect.x + gridSprite.x._ - (gridSize * GRID_DIST) / 4,
			gridRect.y + gridSprite.y._ - (gridSize * GRID_DIST) / 4
		);
		
		//Utils.ConsoleLog(gridRect.x + " " + gridRect.y + " " + gridRect.width + " " + gridRect.height);
		//Utils.ConsoleLog(gridSprite.x + " " + gridSprite.y + " " + gridSprite.getNaturalWidth() + " " + gridSprite.getNaturalHeight());
	}
	
	public function CreateSpawners(): Void {
		boardSpawners = new Array<M3Spawner>();
		
		for (ii in 0...1) {
			var gridArray: Array<M3GridContainer> = new Array<M3GridContainer>();
			for (jj in 0...boardGrids[ii].length) {
				gridArray.push(new M3GridContainer(boardGrids[ii][jj], null));
			}
			
			var grid: Point = GetGridXY(ii, 0);
			var spawner: M3Spawner = new M3Spawner(ii, gridArray);
			spawner.SetSpawnerXY(grid.x, grid.y - (GetGrid(ii, 0).height._));
			boardEntity.addChild(new Entity().add(spawner));
			boardSpawners.push(spawner);
		}
	}
	
	public static function GetGrid(x: Int, y: Int): M3Grid {
		return current.boardGrids[x][y];
	}
	
	public static function GetGridXY(x: Int, y: Int): Point {
		var grid: M3Grid = GetGrid(x, y);
		var result: Point = new Point(grid.x._, grid.y._);
		result.x += current.gridSprite.x._;
		result.y += current.gridSprite.y._;
		return result;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(boardEntity);
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
	}
	
	override public function dispose() 
	{
		super.dispose();
		boardEntity.dispose();
	}
}