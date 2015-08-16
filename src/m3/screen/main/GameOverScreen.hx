package m3.screen.main;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.System;
import flambe.scene.Scene;

import m3.names.AssetName;
import m3.names.ScreenName;
import m3.screen.GameScreen;
/**
 * ...
 * @author Anthony Ganzon
 */
class GameOverScreen extends GameScreen
{

	public function new() 
	{
		super();
		
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
		return ScreenName.SCREEN_GAME_OVER;
	}
	
}