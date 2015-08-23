package m3.screen.main;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.subsystem.StorageSystem;

import m3.name.AssetName;
import m3.name.ScreenName;
import m3.core.SceneManager;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class TitleScreen extends GameScreen
{

	public function new(assetPack:AssetPack, storage:StorageSystem) {
		super(assetPack, storage);
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