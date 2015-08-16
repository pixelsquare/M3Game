package m3.screen;
import flambe.asset.AssetPack;
import flambe.Entity;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.display.ImageSprite;
import flambe.System;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.script.Delay;
import flambe.script.CallFunction;

import m3.names.ScreenName;
import m3.names.AssetName;
import m3.core.GameData;
import m3.core.SceneManager;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class SplashScreen extends GameScreen
{	
	private var screenDuration: Int;
	
	public function new(preloadPack: AssetPack, duration: Int) 
	{
		super();
		gameAssets = preloadPack;
		screenDuration = duration;
	}
	
	override public function CreateScreen():Entity 
	{
		screenEntity = super.CreateScreen();
		screenBackground.color = 0x000000;
		screenEntity.removeChild(new Entity().add(screenTitleText));
		
		var splashImage: ImageSprite = new ImageSprite(gameAssets.getTexture(AssetName.LOGO_PXLSQR));
		splashImage.centerAnchor();
		splashImage.setXY(System.stage.width / 2, System.stage.height * 0.45);
		screenEntity.addChild(new Entity().add(splashImage));
		
		var logoTextFont: Font = new Font(gameAssets, AssetName.FONT_VANADINE_32);
		var logoText: TextSprite = new TextSprite(logoTextFont, "PIXEL SQUARE");
		logoText.centerAnchor();
		logoText.setXY(
			System.stage.width / 2, 
			splashImage.y._ + (splashImage.getNaturalHeight() / 2) + logoText.getNaturalHeight()
		);
		screenEntity.addChild(new Entity().add(logoText));
		
		var script: Script = new Script();
		script.run(new Sequence([
			new Delay(screenDuration),
			new CallFunction(function() {
				SceneManager.current.ShowTitleScreen(true);
			})
		]));
		screenEntity.add(script);
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_SPLASH;
	}
	
}