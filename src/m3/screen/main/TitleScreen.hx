package m3.screen.main;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;

import m3.names.AssetName;
import m3.names.ScreenName;
import m3.core.SceneManager;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class TitleScreen extends GameScreen
{

	public function new() 
	{
		super();
	}
	
	override public function CreateScreen():Entity 
	{
		screenEntity = super.CreateScreen();
		screenBackground.color = 0x202020;
		
		System.pointer.down.connect(function(event: PointerEvent) {
			SceneManager.current.ShowLevelScreen(true);
		}).once();
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_TITLE;
	}
}