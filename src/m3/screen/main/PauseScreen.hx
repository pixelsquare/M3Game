package m3.screen.main;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.System;
import flambe.scene.Scene;
import flambe.asset.AssetPack;
import flambe.subsystem.StorageSystem;

import m3.name.AssetName;
import m3.name.ScreenName;
import m3.screen.GameScreen;

/**
 * ...
 * @author Anthony Ganzon
 */
class PauseScreen extends GameScreen
{
	public function new(assetPack: AssetPack, storage: StorageSystem) {
		super(assetPack, storage);
	}
	
	override public function CreateScreen():Entity 
	{
		screenEntity = super.CreateScreen();
		screenScene = new Scene(false);
		screenBackground.color = 0x000000;
		screenBackground.alpha._ = 0.5;
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_PAUSE;
	}
	
}