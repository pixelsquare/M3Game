package m3.screen.main;

import flambe.display.FillSprite;
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
import flambe.asset.AssetPack;
import flambe.subsystem.StorageSystem;

import m3.name.AssetName;
import m3.name.ScreenName;
import m3.screen.GameScreen;
import m3.core.SceneManager;
import m3.pxlSq.Utils;
import m3.core.GameManager;
import m3.main.M3Main;

/**
 * ...
 * @author Anthony Ganzon
 */
class MainScreen extends GameScreen
{

	public function new(assetPack:AssetPack, storage:StorageSystem) {
		super(assetPack, storage);
	}
	
	override public function CreateScreen(): Entity {
		screenEntity = super.CreateScreen();
		screenBackground.color = 0x202020;
		HideTitleText();
		
		screenEntity.addChild(new Entity().add(GameManager.current.GetM3Main()));
		
		//var sprite1: FillSprite = new FillSprite(0xFFFFFF, 10, 10);
		//sprite1.centerAnchor();
		//sprite1.setXY(System.stage.width / 2, System.stage.height / 2);
		//screenEntity.addChild(new Entity().add(sprite1));
		
		//var sprite2: FillSprite = new FillSprite(0x445522, 10, 10);
		//sprite2.centerAnchor();
		//sprite2.setXY(System.stage.width / 2 + 10, System.stage.height / 2);
		//screenEntity.addChild(new Entity().add(sprite2));
		
		//Utils.ConsoleLog(screenEntity.toString());
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_MAIN;
	}
	
}