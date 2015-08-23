package m3.screen.main;

import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.Rectangle;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.subsystem.StorageSystem;

import m3.name.AssetName;
import m3.name.ScreenName;
import m3.screen.GameScreen;
import m3.core.SceneManager;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class LevelScreen extends GameScreen
{

	public function new(assetPack:AssetPack, storage:StorageSystem) {
		super(assetPack, storage);
	}
	
	override public function CreateScreen():Entity 
	{
		screenEntity = super.CreateScreen();
		screenBackground.color = 0x000000;
		
		var buttonEntity: Entity = new Entity();
		var buttonBG: FillSprite = new FillSprite(0xFFFFFF, 0, 0);
		buttonBG.centerAnchor();
		buttonEntity.addChild(new Entity().add(buttonBG));
		
		var buttonFont: Font = new Font(gameAsset, AssetName.FONT_UNCERTAIN_SANS_32b);
		var buttonText: TextSprite = new TextSprite(buttonFont, "Continue");
		buttonText.centerAnchor();
		buttonEntity.addChild(new Entity().add(buttonText));
		
		buttonBG.width._ = buttonText.getNaturalWidth() + 10;
		buttonBG.height._ = buttonText.getNaturalHeight() + 10;
		buttonText.setXY(buttonBG.getNaturalWidth() / 2, buttonBG.getNaturalHeight() / 2);
		
		var buttonRect: Rectangle = Sprite.getBounds(buttonEntity);
		var buttonSprite: Sprite = new Sprite();
		buttonSprite.setXY(
			(System.stage.width / 2) - (buttonRect.width / 2), 
			(System.stage.height / 2) - (buttonRect.height / 2)
		);
		
		buttonSprite.pointerDown.connect(function(event: PointerEvent) {
			SceneManager.current.ShowMainScreen(true);
			SceneManager.current.ShowGoalScreen(false, 3);
		}).once();
		
		screenEntity.addChild(buttonEntity.add(buttonSprite));
			
		return screenEntity;
	}
	
	private function ShowButtonGrid(): Void {
		var buttonEntity: Entity = new Entity();
		
		for (x in 0...5) {
			for (y in 0...5) {
				var square: FillSprite = new FillSprite(0xFFFFFF, 40, 40);
				square.centerAnchor();
				square.setXY(
					x * 60, 
					y * 60
				);
				buttonEntity.addChild(new Entity().add(square));
			}
		}
		
		var buttonBounds: Rectangle = Sprite.getBounds(buttonEntity);
		var buttonSprite: Sprite = new Sprite();
		buttonSprite.setXY(
			(System.stage.width / 2) - (buttonBounds.width / 2), 
			(System.stage.height * 0.3) - (buttonBounds.height / 2)
		);
		
		screenEntity.addChild(buttonEntity.add(buttonSprite));
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_LEVEL;
	}
	
}