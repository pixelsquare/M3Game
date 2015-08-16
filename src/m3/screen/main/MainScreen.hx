package m3.screen.main;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.input.Key;
import m3.main.M3Main;

import m3.names.AssetName;
import m3.names.ScreenName;
import m3.screen.GameScreen;
import m3.core.SceneManager;
import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class MainScreen extends GameScreen
{

	public function new() 
	{
		super();
	}
	
	override public function CreateScreen():Entity 
	{
		screenEntity = super.CreateScreen();
		screenBackground.color = 0x202020;
		RemoveTitleScreen();
		
		var m3Game: M3Main = new M3Main();
		screenEntity.addChild(m3Game.Init());
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_MAIN;
	}
	
}