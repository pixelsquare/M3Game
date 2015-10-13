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
import format.swf.Data.SCRIndex;
import m3.core.DataManager;
import m3.main.grid.M3Block;
import m3.main.spawner.M3Spawner;
import m3.main.tile.bomb.BombType;
import m3.main.tile.bomb.M3AreaBomb;
import m3.main.tile.bomb.M3ColorBomb;
import m3.main.tile.bomb.M3HLineBomb;
import m3.main.tile.bomb.M3TileBomb;
import m3.main.tile.bomb.M3VLineBomb;
import m3.main.tile.M3Element;
import m3.main.tile.M3Tile;
import m3.main.tile.M3TileData;
import m3.main.utils.M3SwapDirection;
import m3.main.utils.M3Utils;
import m3.main.tile.TileDataType;
import m3.pxlSq.Utils;
import flambe.System;
import m3.core.GameManager;
import m3.main.utils.GameData;
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
	public var bombList(default, null): Array<M3TileBomb>;
	
	public var gameScore(default, null): Int;
	
	public var onTilePointerIn: Signal1<M3Tile>;
	public var onScoreChanged: Signal1<Int>;
	
	private var tileEntity: Entity;
	private var tileDataTypes: Array<M3TileData>;
	
	private var curTile: M3Tile;
	
	public function new(data: DataManager) { }
	
	public function CreateGrid(): Void {
		gridBoard = new Array<Array<M3Block>>();
		bombList = new Array<M3TileBomb>();
		
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
					(System.stage.width / 2) + ((x - (GameData.GRID_ROWS / 2)) * grid.GetNaturalWidth() * GameData.GRID_OFFSET),
					(System.stage.height / 2) + ((y - (GameData.GRID_COLS / 2)) * grid.GetNaturalHeight() * GameData.GRID_OFFSET)
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
					
				var rand: Int = Math.round(Math.random() * Type.allEnums(TileDataType).length);
				var randIndx: Int = rand % (Type.allEnums(TileDataType).length);

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
			spawner.SetXY(gridBoard[ii][0].x._, gridBoard[ii][0].y._ - (gridBoard[ii][0].GetNaturalHeight() * 1.5));
			owner.addChild(new Entity().add(spawner));
			spawner.HideVisual();
		}
	}
	
	public function CreateTile(element: M3Element, grid: M3Block): M3Tile {
		if (tileList == null) {
			tileList = new Array<M3Tile>();
		}
		
		var rand: Int = Math.round(Math.random() * Type.allEnums(TileDataType).length);
		var randIndx: Int = rand % (Type.allEnums(TileDataType).length);
		
		var tile: M3Tile = new M3Tile(GameData.TILE_COLOR);
		tile.data = tileDataTypes[randIndx];
		tile.SetGridID(grid.idx, grid.idy);
		tile.SetSize(GameData.TILE_SIZE, GameData.TILE_SIZE);
		tile.SetParent(owner);
		tile.SetXY(element.x._, element.y._);
		owner.addChild(new Entity().add(tile));
		
		grid.SetBlockTile(tile);
		tileList.push(tile);
		
		return tile;
	}
	
	public function CreateBomb(type: BombType, grid: M3Block): M3TileBomb {	
		Utils.ConsoleLog("Bomb Created! " + type);
		var bomb: M3TileBomb = new M3TileBomb(GameData.TILE_BOMB_COLOR);
		if (type == BombType.AREA_BOMB) {
			bomb = new M3AreaBomb(GameData.TILE_BOMB_COLOR);
		}
		else if (type == BombType.LINE_BOMB_V) {
			bomb = new M3VLineBomb(GameData.TILE_BOMB_COLOR);
		}
		else if (type == BombType.LINE_BOMB_H) {
			bomb = new M3HLineBomb(GameData.TILE_BOMB_COLOR);
		}
		else if (type == BombType.COLOR_BOMB) {
			bomb = new M3ColorBomb(GameData.TILE_BOMB_COLOR);
		}
		
		bomb.SetGridID(grid.idx, grid.idy);
		bomb.SetSize(20, 20);
		bomb.SetParent(owner);
		bomb.SetXY(grid.x._, grid.y._);
		owner.addChild(new Entity().add(bomb));
	
		//gridBoard[grid.idx][grid.idy].SetBlockTile(bomb);
		//grid.SetBlockTile(bomb);
		bombList.push(bomb);
		
		return bomb;
	}
	
	public function GenerateTileTypes(): Void {
		tileDataTypes = new Array<M3TileData>();		
		for (type in Type.allEnums(TileDataType)) {
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
		curTile = null;
		
		
		onTilePointerIn = new Signal1<M3Tile>();
		onTilePointerIn.connect(function(tile: M3Tile) {
			if (pointerIsDown)
				return;
			
			curTile = tile;
		});
		
		//System.pointer.down.connect(function(event: PointerEvent) {				
			//if (curTile == null)
				//return;
			//
			//curTile.dispose();
			//CreateBomb(BombType.LINE_BOMB_H, gridBoard[curTile.idx][curTile.idy]);
		//});
		
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
						curTile.Swap(M3SwapDirection.Right);
					}
					else {
						curTile.Swap(M3SwapDirection.Left);
					}
				}
				else {
					if (direction.y > 0) {
						curTile.Swap(M3SwapDirection.Up);
					}
					else {
						curTile.Swap(M3SwapDirection.Down);
					}
				}
			}
			
			pointerIsDown = false;
			curTile = null;
		});
		
		var script: Script = new Script();
		script.run(new Sequence([
			new Delay(1),
			new CallFunction(function() {
				SetStageDirty();
				gameEntity.removeChild(new Entity().add(script));
				script.dispose();
			})
		]));
		gameEntity.addChild(new Entity().add(script));
	}
	
	public function SetStageDirty(): Void {
		var horizontalMatches: Map<Int, Array<M3Block>> = M3Utils.CheckHorizontalMatches(this);
		var verticalMatches: Map<Int, Array<M3Block>> = M3Utils.CheckVerticalMatches(this);		
		
		if (!horizontalMatches.exists(0) && !verticalMatches.exists(0))
			return;
		
		var intersectingBlocks: Array<M3Block> = new Array<M3Block>();
		
		//var blocks: Array<M3Block> = new Array<M3Block>();
		for (key in verticalMatches.keys()) {
			var blockList: Array<M3Block> = verticalMatches.get(key);
			if (blockList.length > 3) {
				blockList[0].GetTile().dispose();
				var bomb: M3TileBomb = CreateBomb(BombType.LINE_BOMB_V, blockList[0]);
				blockList[0].SetBlockTile(bomb);
				//Utils.ConsoleLog((bomb == null) + "");
			}
			
			for (block in verticalMatches.get(key)) {
				if (block.IsBlockEmpty())
					continue;
				
				block.GetTile().dispose();
				//if (Lambda.has(blocks, block))
					//continue;
					
				//blocks.push(block);
			}
		}
		
		for (key in horizontalMatches.keys()) {
			var blockList: Array<M3Block> = horizontalMatches.get(key);
			if (blockList.length > 3) {
				blockList[0].GetTile().dispose();
				var bomb: M3TileBomb = CreateBomb(BombType.LINE_BOMB_H, blockList[0]);
				blockList[0].SetBlockTile(bomb);
				//Utils.ConsoleLog((bomb == null) + "");
			}
			
			for (block in horizontalMatches.get(key)) {
				if (block.IsBlockEmpty())
					continue;
				
				block.GetTile().dispose();
				//if (Lambda.has(blocks, block)) {
					//intersectingBlocks.push(block);
					//continue;
				//}
					
				//blocks.push(block);
			}
		}		
		
		//for (block in blocks) {
			//block.GetTile().dispose();
		//}
		
		var script: Script = new Script();
		script.run(new Repeat(new Sequence([
			new Delay(0.5),
			new CallFunction(function() { 
				if (!M3Utils.HasMovingBlocks(this) && tileList.length == (GameData.GRID_ROWS * GameData.GRID_COLS) - bombList.length) {
					SetStageDirty();
				
					gameEntity.removeChild(new Entity().add(script));
					script.dispose();
				}
			})
		])));
		gameEntity.addChild(new Entity().add(script));
	}
	
	//override public function onUpdate(dt:Float) 
	//{
		//super.onUpdate(dt);
		//Utils.ConsoleLog(M3Utils.BombCount(this) + "");
		////Utils.ConsoleLog(testBomb.x._ + " " + testBomb.y._);
	//}
}