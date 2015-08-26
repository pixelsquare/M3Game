package m3.main;
import flambe.Component;
import flambe.display.Sprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.math.Rectangle;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Signal1;
import m3.core.DataManager;
import m3.pxlSq.Utils;
import flambe.System;
import m3.core.GameManager;
import m3.main.GameData;
import flambe.input.Key;
import flambe.math.Point;

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
	
	public var gameScore(default, null): Int;
	
	public var onTilePointerIn: Signal1<M3Tile>;
	public var onScoreChanged: Signal1<Int>;
	
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
		AddScore(GameData.TILE_SCORE);
		
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
	
	public function AddScore(score: Int = 1): Void {
		gameScore += score;
		onScoreChanged.emit(gameScore);
	}
	
	public function SubtractScore(score: Int = 1): Void {
		gameScore -= score;
		onScoreChanged.emit(gameScore);
	}
	
	override public function onAdded() {
		super.onAdded();

		gameScore = 0;
		onScoreChanged = new Signal1<Int>();
		
		owner.addChild(gameEntity = new Entity());
		
		gameDisposer = gameEntity.get(Disposer);
		if (gameDisposer == null) {
			gameEntity.add(gameDisposer = new Disposer());
		}
		
		GenerateTileTypes();
		CreateGrid();
		CreateTiles();
		CreateSpawners();
	}
	
	override public function onStart() {
		super.onStart();
		
		var pointerIsDown: Bool = false;
		var startPoint: Point = new Point();
		var endPoint: Point = new Point();
		var curTile: M3Tile = null;
		
		onTilePointerIn = new Signal1<M3Tile>();
		onTilePointerIn.connect(function(tile: M3Tile) {
			if (pointerIsDown)
				return;
			
			curTile = tile;
		});
		
		System.pointer.down.connect(function(event: PointerEvent) {				
			startPoint = new Point(event.viewX - (System.stage.width / 2), (System.stage.height / 2) - event.viewY);
			endPoint = new Point();
			pointerIsDown = true;
		});
		
		System.pointer.up.connect(function(event: PointerEvent) {
			if (!pointerIsDown)
				return;
				
			if (M3Utils.HasMovingBlocks(this))
				return;
				
			endPoint = new Point(event.viewX - (System.stage.width / 2), (System.stage.height / 2) - event.viewY);
			
			var direction: Point = new Point(
				endPoint.x - startPoint.x,
				endPoint.y - startPoint.y
			);
			
			if(curTile != null) {
				if (Math.abs(direction.x) > Math.abs(direction.y)) {
					if (direction.x > 0) {
						curTile.SwapTo(M3SwapDirection.Right);
					}
					else {
						curTile.SwapTo(M3SwapDirection.Left);
					}
				}
				else {
					if (direction.y > 0) {
						curTile.SwapTo(M3SwapDirection.Up);
					}
					else {
						curTile.SwapTo(M3SwapDirection.Down);
					}
				}
			}
			
			pointerIsDown = false;
			curTile = null;
		});
		
		SetStageDirty();
	}
	
	public function SetStageDirty(): Void {
		var horizontalMatches: Map<Int, Array<M3Block>> = M3Utils.CheckHorizontalMatches(this);
		var verticalMatches: Map<Int, Array<M3Block>> = M3Utils.CheckVerticalMatches(this);		
		
		if (!horizontalMatches.exists(0) && !verticalMatches.exists(0))
			return;
			
		var blocks: Array<M3Block> = new Array<M3Block>();
		for (key in verticalMatches.keys()) {
			for (block in verticalMatches.get(key)) {
				if (block.IsBlockEmpty())
					continue;
				
				if (Lambda.has(blocks, block))
					continue;
					
				blocks.push(block);
			}
		}
		
		for (key in horizontalMatches.keys()) {
			for (block in horizontalMatches.get(key)) {
				if (block.IsBlockEmpty())
					continue;
				
				if (Lambda.has(blocks, block))
					continue;
					
				blocks.push(block);
			}
		}		
		
		for (block in blocks) {
			block.GetTile().dispose();
		}
		
		var script: Script = new Script();
		script.run(new Repeat(new Sequence([
			new Delay(0.5),
			new CallFunction(function() { 
				if (!M3Utils.HasMovingBlocks(this) && tileList.length == (GameData.GRID_ROWS * GameData.GRID_COLS)) {
					SetStageDirty();
				
					gameEntity.removeChild(new Entity().add(script));
					script.dispose();
				}
			})
		])));
		gameEntity.addChild(new Entity().add(script));
	}
}