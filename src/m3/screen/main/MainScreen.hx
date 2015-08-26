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

		var scoreFont: Font = new Font(gameAsset, AssetName.FONT_BETTY_32);
		var scoreText: TextSprite = new TextSprite(scoreFont, "SCORE:\n0");
		scoreText.centerAnchor();
		scoreText.setAlign(TextAlign.Center);
		scoreText.setXY(
			System.stage.width * 0.9,
			System.stage.height * 0.45
		);
		screenEntity.addChild(new Entity().add(scoreText));
		
		GameManager.current.GetM3Main().onScoreChanged.connect(function(score: Int) {
			scoreText.text = "SCORE:\n" + score;
		});
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_MAIN;
	}
	
}