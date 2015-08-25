package m3.main;
import flambe.Component;
import flambe.display.Sprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.math.Rectangle;
import m3.core.DataManager;
import m3.pxlSq.Utils;
import flambe.System;
import m3.core.GameManager;
import m3.main.GameData;
import flambe.input.Key;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Main extends Component
{
	private var gameEntity: Entity;
	private var gameDisposer: Disposer;
	
	public var gridBoard(default, null): Array<Array<M3Block>>;
	public var tileList(default, null): Array<M3Tile>;
	
	private var tileEntity: Entity;
	private var tileDataTypes: Array<M3TileData>;
	
	public function new(data: DataManager) { }
	
	public function CreateGrid(): Void {
		gridBoard = new Array<Array<M3Block>>();
		
		var x: Int = 0, i: Int = 0;
		while (x < GameData.GRID_ROWS) {
			
			var gridArray: Array<M3Block> = new Array<M3Block>();
			var y: Int = 0;
			while (y < GameData.GRID_COLS) {				
				var grid: M3Block = new M3Block((i % 2 == 0) ? GameData.GRID_COLOR_1 : GameData.GRID_COLOR_2);
				grid.SetGridID(x, y);
				grid.SetSize(GameData.GRID_SIZE, GameData.GRID_SIZE);	
				grid.SetParent(owner);
				grid.SetXY(
					(System.stage.width / 2) + ((x - (GameData.GRID_ROWS / 2)) * grid.width * GameData.GRID_OFFSET),
					(System.stage.height / 2) + ((y - (GameData.GRID_COLS / 2)) * grid.height * GameData.GRID_OFFSET)
				);
				owner.addChild(new Entity().add(grid));
				
				gridArray.push(grid);
				
				y++;
				i++;
			}
			
			gridBoard.push(gridArray);
			x++;
			i--;
		}		
		
		//gridBoard[1][1].SetBlocked();
		//gridBoard[1][3].SetBlocked();
		//gridBoard[8][1].SetBlocked();
		//gridBoard[0][9].SetBlocked();
	}
	
	public function CreateTiles(): Void {
		tileList = new Array<M3Tile>();
		
		for(ii in 0...gridBoard.length) {
			for (grid in gridBoard[ii]) {
				if (grid.IsBlocked())
					continue;
					
				var rand: Int = Math.round(Math.random() * Type.allEnums(TileType).length);
				var randIndx: Int = rand % (Type.allEnums(TileType).length - 3);

				var tile: M3Tile = new M3Tile(GameData.TILE_COLOR);
				tile.data = tileDataTypes[randIndx];
				tile.SetGridID(grid.idx, grid.idy);
				tile.SetSize(GameData.TILE_SIZE, GameData.TILE_SIZE);
				tile.SetParent(owner);
				tile.SetXY(grid.x._, grid.y._);
				owner.addChild(new Entity().add(tile));

				grid.SetBlockTile(tile);	
				tileList.push(tile);
			}
		}
	}
	
	public function CreateSpawners(): Void {
		for (ii in 0...GameData.GRID_ROWS) {
			var spawner:M3Spawner = new M3Spawner();
			spawner.SetGridID(ii, 0);
			spawner.SetSize(15, 15);
			spawner.SetParent(owner);
			spawner.SetXY(gridBoard[ii][0].x._, gridBoard[ii][0].y._ - (gridBoard[ii][0].height * 1.5));
			owner.addChild(new Entity().add(spawner));
			spawner.HideVisual();
		}
	}
	
	public function CreateTile(spawner: M3Spawner, grid: M3Block): M3Tile {
		if (tileList == null) {
			tileList = new Array<M3Tile>();
		}
		
		var rand: Int = Math.round(Math.random() * Type.allEnums(TileType).length);
		var randIndx: Int = rand % Type.allEnums(TileType).length;
		
		var tile: M3Tile = new M3Tile(GameData.TILE_COLOR);
		tile.data = tileDataTypes[randIndx];
		tile.SetGridID(grid.idx, grid.idy);
		tile.SetSize(GameData.TILE_SIZE, GameData.TILE_SIZE);
		tile.SetParent(owner);
		tile.SetXY(spawner.x._, spawner.y._);
		owner.addChild(new Entity().add(tile));
		
		grid.SetBlockTile(tile);
		tileList.push(tile);
		
		return tile;
	}
	
	public function GenerateTileTypes(): Void {
		tileDataTypes = new Array<M3TileData>();		
		for (type in Type.allEnums(TileType)) {
			var tileData: M3TileData = new M3TileData();
			tileData.TileDataType = type;
			tileData.TileColor = M3Utils.GetTileColor(type);
			tileDataTypes.push(tileData);
		}
	}
	
	public function RemoveTile(gridTile: M3Tile): Void {	
		gridBoard[gridTile.idx][gridTile.idy].SetBlockTile(null);
		
		for (tile in tileList) {
			if (tile == gridTile) {
				tileList.remove(tile);
			}
		}
	}
	
	public function GetTile(idx: Int, idy: Int): M3Tile {
		for (tile in tileList) {
			if (tile.idx == idx && tile.idy == idy) {
				return tile;
			}
		}
		
		return null;
	}
	
	public function GetTileCount(): Int {
		var result: Int = 0;
		for (tile in tileList) {
			if (tile == null)
				continue;
			
			result++;
		}
		
		return result;
	}
	
	public function SetTilesFillCount(count: Int): Void {
		//Utils.ConsoleLog(count +"");
		for (tile in tileList) {
			if (tile != null) {
				tile.SetFillCount(count);
			}
		}
	}
	
	override public function onAdded() {
		super.onAdded();
		
		owner.addChild(gameEntity = new Entity());
		
		gameDisposer = gameEntity.get(Disposer);
		if (gameDisposer == null) {
			gameEntity.add(gameDisposer = new Disposer());
		}
		
		GenerateTileTypes();
		CreateGrid();
		CreateTiles();
		//CreateSpawners();
		
		//var num: Int = 0;
		//for (ii in 0...9) {
			//var tmp: Int = (ii < num) ? (num - ii) - 1 : ii + 1;
			//Utils.ConsoleLog(tmp + "");
		//}
		
		//var test: Map<Int, Array<M3Block>> = M3Utils.CheckMatchCombo(this);
		//for (key in test.keys()) {
			//Utils.ConsoleLog(key + " " + test.get(key).length + "");
		//}
		
		System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.Space) {
				for (key in M3Utils.CheckMatchCombo(this).keys()) {
					var a: Array<M3Block> = M3Utils.CheckMatchCombo(this).get(key);
					for (b in a) {
						b.dispose();
					}
				}
			}
		});
		
		//var tmp: Map<Int, String> = new Map<Int, String>();
		//tmp.set(0, "ASD");
		//tmp.set(1, "QWE");
		//
		//for (key in tmp.keys()) {
			//Utils.ConsoleLog(tmp.get(key));
		//}
	}
	
	//override public function onUpdate(dt:Float) {
		//super.onUpdate(dt);
		//if (tileList.length > 0) {
			//Utils.ConsoleLog(tileList[0].fillCount + "");
			////Utils.ConsoleLog(gridBoard[1][3].IsBlockEmpty());
		//}
	//}
}