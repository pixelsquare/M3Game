package m3.main;
import flambe.Entity;
import flambe.math.Point;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class M3Utils
{
	public static function GetBottomTileIndx(m3Main: M3Main, tile: M3Tile): UInt {
		var result: UInt = 0;
		
		for (grid in m3Main.gridBoard[tile.idx]) {
				if (!grid.IsBlocked()) {
					result++;
				}
		}
		
		return result;
	}
	
	public static function GetTileColor(type: TileType): Int {
		if (type == TileType.Tile_Type_1) {
			return GameData.TILE_TYPE_1_COLOR;
		}
		else if (type == TileType.Tile_Type_1) {
			return GameData.TILE_TYPE_1_COLOR;
		}
		else if (type == TileType.Tile_Type_2) {
			return GameData.TILE_TYPE_2_COLOR;
		}
		else if (type == TileType.Tile_Type_3) {
			return GameData.TILE_TYPE_3_COLOR;
		}
		else if (type == TileType.Tile_Type_4) {
			return GameData.TILE_TYPE_4_COLOR;
		}
		else if (type == TileType.Tile_Type_5) {
			return GameData.TILE_TYPE_5_COLOR;
		}
		else if (type == TileType.Tile_Type_6) {
			return GameData.TILE_TYPE_6_COLOR;
		}
		return 0;
	}
	
	public static function SwapTiles(blockA: M3Block, blockB: M3Block, entity: Entity, ?swapSpd: Float = 0.5, ?fn:Void->Void): Void {
		if (blockA.IsBlocked() || blockA.IsBlockEmpty())
			return;
		
		if (blockB.IsBlocked() || blockB.IsBlockEmpty())
			return;
			
		var tileA: M3Tile = blockA.GetTile();
		var tileB: M3Tile = blockB.GetTile();
		
		var tmpTileBPos: Point = new Point(tileB.x._, tileB.y._);
		var tmpTileBIdx: Int = tileB.idx; var tmpTileBIdy: Int = tileB.idy;
		
		tileA.isAnimating = true;
		tileB.isAnimating = true;
		
		var script: Script = new Script();
		script.run(new Sequence([
			new Parallel([
				new AnimateTo(tileA.x, tmpTileBPos.x, swapSpd),
				new AnimateTo(tileB.x, tileA.x._, swapSpd),
				new AnimateTo(tileA.y, tmpTileBPos.y, swapSpd),
				new AnimateTo(tileB.y, tileA.y._, swapSpd)
			]),
			new CallFunction(function() {
				tileB.SetGridID(tileA.idx, tileA.idy);
				tileA.SetGridID(tmpTileBIdx, tmpTileBIdy);
				
				blockA.SetBlockTile(tileB);
				blockB.SetBlockTile(tileA);
				
				entity.removeChild(new Entity().add(script));
				script.dispose();
				
				tileA.isAnimating = false;
				tileB.isAnimating = false;
				
				if (fn != null) { fn(); }
			})
		]));
		entity.addChild(new Entity().add(script));
	}
	
	public static function GetBlockToSwap(tile: M3Tile, m3Main: M3Main, swapDir: M3SwapDirection): M3Block {
		var result: M3Block = null;
		
		if (swapDir == M3SwapDirection.Left) {
			result = m3Main.gridBoard[tile.idx - 1][tile.idy];
		}
		else if (swapDir == M3SwapDirection.Right) {
			result = m3Main.gridBoard[tile.idx + 1][tile.idy];
		}
		else if (swapDir == M3SwapDirection.Up) {
			result = m3Main.gridBoard[tile.idx][tile.idy - 1];
		}
		else if (swapDir == M3SwapDirection.Down) {
			result = m3Main.gridBoard[tile.idx][tile.idy + 1];
		}
		
		return result;
	}
	
	public static function CheckHorizontal(tile: M3Tile, m3Main: M3Main): Array<M3Block> {
		var result: Array<M3Block> = new Array<M3Block>();
		
		var tileIdx: Int = tile.idx;
		var tileIdy: Int = tile.idy;
		
		while (tileIdx > 0) {
			if (m3Main.gridBoard[tileIdx - 1][tileIdy].GetTile().data.TileDataType != tile.data.TileDataType)
				break;
			
			result.push(m3Main.gridBoard[tileIdx - 1][tileIdy]);
			tileIdx--;
		}
		
		tileIdx = tile.idx;
		while (tileIdx < GameData.GRID_ROWS) {
			if (m3Main.gridBoard[tileIdx + 1][tileIdy].GetTile().data.TileDataType != tile.data.TileDataType)
				break;
			
			result.push(m3Main.gridBoard[tileIdx + 1][tileIdy]);
			
			tileIdx++;
		}

		return result;
	}
	
	public static function CheckVertical(tile: M3Tile, m3Main: M3Main): Array<M3Block> {
		var result: Array<M3Block> = new Array<M3Block>();
		
		var tileIdx: Int = tile.idx;
		var tileIdy: Int = tile.idy;
		
		while (tileIdy > 0) {
			if (m3Main.gridBoard[tileIdx][tileIdy - 1].GetTile().data.TileDataType != tile.data.TileDataType)
				break;
			
			result.push(m3Main.gridBoard[tileIdx][tileIdy - 1]);
			tileIdy--;	
		}
	
		tileIdy = tile.idy;
		while (tileIdy < GameData.GRID_ROWS) {
			if (m3Main.gridBoard[tileIdx][tileIdy + 1].GetTile().data.TileDataType != tile.data.TileDataType)
				break;
			
			result.push(m3Main.gridBoard[tileIdx][tileIdy + 1]);
			
			tileIdy++;
		}
		
		return result;
	}
	
	public static function CheckVerticalMatches(m3Main: M3Main): Map<Int, Array<M3Block>> {
		var result: Map<Int, Array<M3Block>> = new Map<Int, Array<M3Block>>();
		
		var id: Int = 0;
		var curBlock: M3Block = null;
		var matches: Array<M3Block> = new Array<M3Block>();
		
		for (x in 0...GameData.GRID_ROWS) {		
			for (y in 0...GameData.GRID_COLS) {
				if(curBlock == null) {
					curBlock = m3Main.gridBoard[x][y];
					matches.push(curBlock);
					continue;
				}
				else {
					var block: M3Block = m3Main.gridBoard[x][y];
					if (block.IsBlocked())
						continue;
						
					if (curBlock.GetTile().data.TileDataType != block.GetTile().data.TileDataType) {
						if (matches.length > 2) {
							result.set(id, matches);
							id++;
						}
						matches = new Array<M3Block>();
						curBlock = block;
						matches.push(curBlock);
						continue;
					}
					
					
					matches.push(block);
				}
			}
			
			if (matches.length > 2) {
				result.set(id, matches);
				id++;				
			}
			matches = new Array<M3Block>();
			curBlock = null;
		}
		
		return result;
	}
	
	public static function CheckHorizontalMatches(m3Main: M3Main): Map<Int, Array<M3Block>> {
		var result: Map<Int, Array<M3Block>> = new Map<Int, Array<M3Block>>();
		
		var id: Int = 0;
		var curBlock: M3Block = null;
		var matches: Array<M3Block> = new Array<M3Block>();
		
		for (y in 0...GameData.GRID_COLS) {		
			for (x in 0...GameData.GRID_ROWS) {
				if(curBlock == null) {
					curBlock = m3Main.gridBoard[x][y];
					matches.push(curBlock);
					continue;
				}
				else {
					var block: M3Block = m3Main.gridBoard[x][y];
					if (block.IsBlocked())
						continue;
						
					if (curBlock.GetTile().data.TileDataType != block.GetTile().data.TileDataType) {
						if (matches.length > 2) {
							result.set(id, matches);
							id++;
						}
						matches = new Array<M3Block>();
						curBlock = block;
						matches.push(curBlock);
						continue;
					}
					
					
					matches.push(block);
				}				
			}
			
			if (matches.length > 2) {
				result.set(id, matches);
				id++;				
			}
			matches = new Array<M3Block>();
			curBlock = null;
		}
		
		return result;
	}
	
	public static function CheckMatchCombo(m3Main: M3Main): Map<Int, Array<M3Block>> {
		var result: Map<Int, Array<M3Block>> = new Map<Int, Array<M3Block>>();
		var verticalMatches: Map<Int, Array<M3Block>> = CheckVerticalMatches(m3Main);
		var horizontalMatches: Map<Int, Array<M3Block>> = CheckHorizontalMatches(m3Main);
		
		var id: Int = 0;
		for (vKey in verticalMatches.keys()) {
			
			var vertBlocks: Array<M3Block> = verticalMatches.get(vKey);
			for (vert in verticalMatches.get(vKey)) {
				var leftBlock: M3Block = m3Main.gridBoard[vert.GetTile().idx - 1][vert.GetTile().idy];
				var rightBlock: M3Block = m3Main.gridBoard[vert.GetTile().idx + 1][vert.GetTile().idy];
				
				if ((leftBlock != null && leftBlock.GetTile().data.TileDataType == vert.GetTile().data.TileDataType) ||
					(rightBlock != null && rightBlock.GetTile().data.TileDataType == vert.GetTile().data.TileDataType)) {
						for (hKey in horizontalMatches.keys()) {
							
							var horizBlocks: Array<M3Block> = horizontalMatches.get(hKey);
							for (horiz in horizontalMatches.get(hKey)) {
								if (horiz == vert) {
									var combo: Array<M3Block> = new Array<M3Block>();
									if (vertBlocks != null) {
										for (block in vertBlocks) {
											combo.push(block);
										}
									}
									//Utils.ConsoleLog((horizBlocks == null) + "");
									if (horizBlocks != null) {
										for (block in horizBlocks) {
											combo.push(block);
										}
									}
									//Utils.ConsoleLog(horiz.idx + " " + horiz.idy);
									//var combo: Array<M3Block> = verticalMatches.get(vKey);
									//for (block in horizBlocks) {
										//combo.push(block);
									//}
									//var combo: Array<M3Block> = new Array<M3Block>();
									//combo.concat(vertBlocks);
									//combo.concat(horizBlocks);
									result.set(id, combo);
									id++;
								}
							}
						}
					}
			}
		}
		
		//var id: Int = 0;
		//for (vKeys in verticalMatches.keys()) {
			//for (hKeys in horizontalMatches.keys()) {
				//for (vertical in verticalMatches.get(vKeys)) {
					//for (horizontal in horizontalMatches.get(hKeys)) {
						//if (vertical == horizontal) {
							//var combo: Array<M3Block> = new Array<M3Block>();
							//combo.concat(verticalMatches.get(vKeys));
							//combo.concat(horizontalMatches.get(hKeys));
							//result.set(id, combo);
							//id++;
						//}
					//}
				//}
			//}
		//}
		
		return result;
	}
	
	public static function HasMovingBlocks(m3Main: M3Main): Bool {
		var count: Int = 0;
		
		for (tile in m3Main.tileList) {
			if (tile != null && !tile.isAnimating)
				continue;
				
			count++;
		}

		return count > 0;
	}
}