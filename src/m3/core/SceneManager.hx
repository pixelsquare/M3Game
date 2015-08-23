package m3.core;

import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.scene.Director;
import flambe.scene.SlideTransition;
import flambe.scene.FadeTransition;
import flambe.animation.Ease;
import flambe.subsystem.StorageSystem;
import flambe.System;
import flambe.math.FMath;
import flambe.display.Sprite;
import flambe.display.FillSprite;
import flambe.display.TextSprite;

import m3.screen.GameScreen;
import m3.screen.PreloadScreen;
import m3.screen.SplashScreen;
import m3.screen.main.TitleScreen;
import m3.screen.main.LevelScreen;
import m3.screen.main.GoalScreen;
import m3.screen.main.MainScreen;
import m3.screen.main.PauseScreen;
import m3.screen.main.GameOverScreen;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class SceneManager
{
	public var gameTitleScreen(default, null): TitleScreen;
	public var gameLevelScreen(default, null): LevelScreen;
	public var gameGoalScreen(default, null): GoalScreen;
	public var gameMainScreen(default, null): MainScreen;
	public var gamePauseScreen(default, null): PauseScreen;
	public var gameOverScreen(default, null): GameOverScreen;
	
	private var gameScreenList: Array<GameScreen>;
	private var gameDirector: Director;
	
	public static var curSceneEntity(default, null): Entity;
	public static var current(default, null): SceneManager;
	
	private static inline var DURATION_SHORT: Float = 0.5;
	private static inline var DURATION_LONG: Int = 1;
	
	public static inline var TARGET_WIDTH: 	Int = 640;
	public static inline var TARGET_HEIGHT: Int = 800;
	
	public function new(director: Director) 
	{
		current = this;
		gameDirector = director;
		
		//System.stage.resize.connect(function() {
			//var targetWidth: Int = TARGET_WIDTH;
			//var targetHeight: Int = TARGET_HEIGHT;
			//
			//var scale = FMath.min(System.stage.width / targetWidth, System.stage.height / targetHeight);
			//if (scale > 1) scale = 1;
			//
			//for (screen in gameScreenList) {
				//screen.screenEntity.get(Sprite).setScale(scale).setXY(
					//(System.stage.width - targetWidth * scale) / 2, 
					//(System.stage.height - targetHeight * scale) / 2
				//);
			//}
		//});
	}
	
	public function InitScreens(assetPack: AssetPack, storage: StorageSystem): Void {
		AddGameScreen(gameTitleScreen = new TitleScreen(assetPack, storage));
		AddGameScreen(gameLevelScreen = new LevelScreen(assetPack, storage));
		AddGameScreen(gameGoalScreen = new GoalScreen(assetPack, storage));
		AddGameScreen(gameMainScreen = new MainScreen(assetPack, storage));
		AddGameScreen(gamePauseScreen = new PauseScreen(assetPack, storage));
		AddGameScreen(gameOverScreen = new GameOverScreen(assetPack, storage));
	}
	
	private function AddGameScreen(screen: GameScreen) : Void {
		if (gameScreenList == null) {
			gameScreenList = new Array<GameScreen>();
		}
		
		gameScreenList.push(screen);
	}
	
	public function UnwindToScene(scene: Entity): Void {
		gameDirector.unwindToScene(scene);
	}
	
	public function ShowScreen(gameScreen: GameScreen, willAnimate: Bool = false): Void {
		gameDirector.unwindToScene(gameScreen.CreateScreen(),
			willAnimate ? new FadeTransition(DURATION_SHORT, Ease.linear) : null);
		curSceneEntity = gameScreen.screenEntity;
	}
	
	public function ShowTitleScreen(willAnimate: Bool = false): Void {
		gameDirector.unwindToScene(gameTitleScreen.CreateScreen(),
			willAnimate ? new FadeTransition(DURATION_SHORT, Ease.linear) : null);
		curSceneEntity = gameTitleScreen.screenEntity;
	}
	
	public function ShowLevelScreen(willAnimate: Bool = false): Void {
		gameDirector.unwindToScene(gameLevelScreen.CreateScreen(),
			willAnimate ? new FadeTransition(DURATION_SHORT, Ease.linear) : null);
		curSceneEntity = gameLevelScreen.screenEntity;
	}
	
	public function ShowGoalScreen(willAnimate: Bool = false, duration: Int): Void {
		gameGoalScreen.Init(duration);
		gameDirector.pushScene(gameGoalScreen.CreateScreen());
		gameGoalScreen.ShowScreen();
	}
	
	public function ShowMainScreen(willAnimate: Bool = false): Void {
		gameDirector.unwindToScene(gameMainScreen.CreateScreen(),
			willAnimate ? new FadeTransition(DURATION_SHORT, Ease.linear) : null);
		curSceneEntity = gameMainScreen.screenEntity;
	}
	
	public function ShowPauseScreen(willAnimate: Bool = false): Void {	
		gameDirector.pushScene(gamePauseScreen.CreateScreen());
		//gameDirector.unwindToScene(gamePauseScreen.CreateScreen());
	}
	
	public function ShowGameOverScreen(willANimate: Bool = false) : Void {
		gameDirector.pushScene(gameOverScreen.CreateScreen());
		//gameDirector.unwindToScene(gameOverScreen.CreateScreen());
	}
}