package m3.core;
import flambe.asset.AssetPack;
import flambe.scene.Director;
import flambe.subsystem.StorageSystem;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameData
{
	public var gameAssets: AssetPack;
	public var gameStorage: StorageSystem;
	
	public static var current(default, null): GameData;
	
	public function new(assets: AssetPack, storage: StorageSystem) 
	{
		current = this;
		gameAssets = assets;
		gameStorage = storage;
	}
}