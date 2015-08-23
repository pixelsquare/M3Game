package m3.main;
import flambe.Component;
import flambe.display.Sprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.math.Rectangle;
import m3.core.DataManager;
import m3.pxlSq.Utils;
import flambe.System;
import m3.core.GameManager;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Main extends Component
{
	private var gameEntity: Entity;
	private var gameDisposer: Disposer;
	
	public var gridBoard(default, null): Array<Array<M3Grid>>;
	public var gridList(default, null): Array<M3Grid>;
	public var tileList(default, null): Array<M3Tile>;
	
	private var tileEntity: Entity;
	
	private inline static var GRID_ROWS: Int = 10;
	private inline static var GRID_COLS: Int = 10;
	private inline static var GRID_SIZE: Int = 30;
	private inline static var GRID_OFFSET: Float = 1.1;
	private inline static var GRID_COLOR: Int = 0xFFFFFF;
	
	private inline static var TILE_SIZE = 10;
	private inline static var TILE_COLOR: Int = 0x66CD00;
	
	public function new(data: DataManager) { }
	
	public function CreateGrid(): Void {
		gridBoard = new Array<Array<M3Grid>>();
		gridList = new Array<M3Grid>();
		
		var x: Int = 0, i: Int = 0;
		while (x < GRID_ROWS) {
			
			var gridArray: Array<M3Grid> = new Array<M3Grid>();
			var y: Int = 0;
			while (y < GRID_COLS) {				
				var grid: M3Grid = new M3Grid(GRID_COLOR);
				grid.SetGridID(i, x, y);
				grid.SetSize(GRID_SIZE, GRID_SIZE);	
				grid.SetParent(owner);
				grid.SetXY(
					(System.stage.width / 2) + ((x - (GRID_ROWS / 2)) * grid.width * GRID_OFFSET),
					(System.stage.height / 2) + ((y - (GRID_COLS / 2)) * grid.height * GRID_OFFSET)
				);
				owner.addChild(new Entity().add(grid));
				
				gridArray.push(grid);
				gridList.push(grid);
				
				y++;
				i++;
			}
			
			gridBoard.push(gridArray);
			x++;
		}
	}
	
	public function CreateTiles(): Void {
		tileList = new Array<M3Tile>();
		
		for (grid in gridList) {
			var tile: M3Tile = new M3Tile(TILE_COLOR);
			tile.SetGridID(grid.id, grid.idx, grid.idy);
			tile.SetSize(TILE_SIZE, TILE_SIZE);
			tile.SetParent(owner);
			tile.SetXY(
				grid.x,
				grid.y
			);
			owner.addChild(new Entity().add(tile));

			grid.SetTile(tile);	
			gridBoard[grid.idx][grid.idy].SetTile(tile);
			tileList.push(tile);
		}
	}
	
	override public function onAdded() {
		super.onAdded();
		
		owner.addChild(gameEntity = new Entity());
		
		gameDisposer = gameEntity.get(Disposer);
		if (gameDisposer == null) {
			gameEntity.add(gameDisposer = new Disposer());
		}
		
		CreateGrid();
		CreateTiles();
		
		//gridBoard[0][1].dispose();
		
		//Utils.ConsoleLog(owner.has(M3Main) + "");
		//Utils.ConsoleLog(owner.toString());
	}
}