package m3.screen;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.System;
import flambe.util.Promise;
import flambe.display.Font;
import flambe.display.TextSprite;

import m3.names.ScreenName;
import m3.names.AssetName;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class PreloadScreen extends GameScreen
{

	private var promise: Promise<Dynamic>;
	
	private static inline var BACKGROUND_COLOR: Int = 0x202020;
	private static inline var LOADING_BAR_COLOR: Int = 0xFFFFFF;
	
	public function new(preloadAsset: AssetPack, promise: Promise<Dynamic>) 
	{
		super();
		gameAssets = preloadAsset;
		this.promise = promise;
	}
	
	override public function CreateScreen(): Entity 
	{
		screenEntity = super.CreateScreen();
		screenBackground.color = BACKGROUND_COLOR;
		screenEntity.removeChild(new Entity().add(screenTitleText));
		
		var loadingFont: Font = new Font(gameAssets, AssetName.FONT_VANADINE_32);
		var loadingText: TextSprite = new TextSprite(loadingFont, "LOADING .. ");
		loadingText.centerAnchor();
		loadingText.setXY(System.stage.width / 2, System.stage.height * 0.4);
		screenEntity.addChild(new Entity().add(loadingText));
		
		var padding: Int = 50;
		var progressWidth: Float = System.stage.width - (padding * 2);
		
		var loadingBarBG: FillSprite = new FillSprite(LOADING_BAR_COLOR, progressWidth + (padding / 2), 33);
		loadingBarBG.centerAnchor();
		loadingBarBG.setXY(System.stage.width / 2, System.stage.height * 0.55);
		screenEntity.addChild(new Entity().add(loadingBarBG));
		
		var loadingBG: FillSprite = new FillSprite(BACKGROUND_COLOR, loadingBarBG.width._ * 0.98, 30);
		loadingBG.centerAnchor();
		loadingBG.setXY(loadingBarBG.x._, loadingBarBG.y._);
		screenEntity.addChild(new Entity().add(loadingBG));
		
		var loadingBar: FillSprite = new FillSprite(LOADING_BAR_COLOR, 0, 10);
		loadingBar.setXY(
			(System.stage.width / 2) - (loadingBG.width._ * 0.475), 
			loadingBG.y._ - (loadingBar.getNaturalHeight() / 2)
		);
		screenEntity.addChild(new Entity().add(loadingBar));
		
		// Set maximum width relative to loading bg
		//progressWidth = loadingBG.width._ * 0.95;
		
		promise.progressChanged.connect(function() {
			var percentage: Float = promise.progress / promise.total;
			loadingBar.width._ = percentage * progressWidth;
			loadingText.text = "LOADING .. " + Std.int(percentage * 100) + "%";
			loadingText.centerAnchor();
			loadingText.setXY(System.stage.width / 2, System.stage.height * 0.45);
		});
		
		
		return screenEntity;
	}
	
	override public function GetScreenName(): String 
	{
		return ScreenName.SCREEN_PRELOAD;
	}
}