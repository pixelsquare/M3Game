package m3.core;

import flambe.asset.AssetPack;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.subsystem.StorageSystem;
import m3.main.M3Main;

import m3.core.DataManager;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameManager
{
	private var gameDataManager: DataManager;
	private var m3Main: M3Main;
	
	public static var current: GameManager;
	
	public function new(assetPack: AssetPack, storage: StorageSystem) {
		current = this;
		
		gameDataManager = new DataManager(assetPack, storage);
		m3Main = new M3Main(gameDataManager);
	}
	
	public function GetGameData(): DataManager {
		return gameDataManager;
	}
	
	public function GetM3Main(): M3Main {
		return m3Main;
	}
}