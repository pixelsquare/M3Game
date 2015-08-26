package m3;

import flambe.Entity;
import flambe.scene.FadeTransition;
import flambe.scene.Scene;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.util.Promise;
import flambe.scene.Director;
import flambe.subsystem.StorageSystem;
import haxe.io.Input;
import m3.screen.PreloadScreen;
import m3.screen.SplashScreen;
import m3.core.GameManager;
import m3.core.SceneManager;
import m3.pxlSq.Utils;

class Main
{
	private static inline var PRELOAD_PACK: String = "preload";
	private static inline var MAIN_PACK: String = "main";
	
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();
		
		var gameDirector: Director = new Director();
		System.root.add(gameDirector);
		
		System.loadAssetPack(Manifest.fromAssets(PRELOAD_PACK)).get(function(preloadPack: AssetPack) {
			Utils.ConsoleLog("Preload pack loaded");
			var sceneManager: SceneManager = new SceneManager(gameDirector);
			
			var promise: Promise<AssetPack> = System.loadAssetPack(Manifest.fromAssets(MAIN_PACK));
			promise.get(function(mainPack: AssetPack) {
				Utils.ConsoleLog("Main pack loaded");				
				
				var gameManager: GameManager = new GameManager(mainPack, System.storage);
				sceneManager.InitScreens(mainPack, System.storage);
				//sceneManager.ShowLevelScreen();
				//sceneManager.ShowMainScreen();
				sceneManager.ShowScreen(new SplashScreen(preloadPack, 2), true);
			});
			
			sceneManager.ShowScreen(new PreloadScreen(preloadPack, promise));
		});
    }
}