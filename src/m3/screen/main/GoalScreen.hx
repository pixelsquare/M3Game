package m3.screen.main;

import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.scene.Scene;
import flambe.animation.Ease;

import m3.names.AssetName;
import m3.names.ScreenName;
import m3.screen.GameScreen;
import m3.core.SceneManager;

import m3.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class GoalScreen extends GameScreen
{

	private var goalTitleSprite: Sprite;
	private var goalInfoSprite: Sprite;
	
	private var screenDuration: Int;
	
	public function new() 
	{
		super();
	}
	
	public function Init(duration: Int) {
		screenDuration = duration;
	}
	
	override public function CreateScreen():Entity 
	{
		screenEntity = super.CreateScreen();
		screenBackground.color = 0x202020;
		screenBackground.alpha.animate(0, 0.5, 1);
		RemoveTitleScreen();
		
		var goalTitleEntity: Entity = new Entity();
		var goalTitleBg: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height * 0.05);
		goalTitleBg.centerAnchor();
		goalTitleBg.setXY(System.stage.width / 2, System.stage.height * 0.25);
		goalTitleEntity.addChild(new Entity().add(goalTitleBg));
		
		var goalTitleFont: Font = new Font(gameAssets, AssetName.FONT_VANADINE_32);
		var goalTitleText: TextSprite = new TextSprite(goalTitleFont, "GOAL");
		goalTitleText.centerAnchor();
		goalTitleText.setXY(goalTitleBg.getNaturalWidth() * 0.75, goalTitleBg.y._);
		goalTitleEntity.addChild(new Entity().add(goalTitleText));
		
		goalTitleSprite = new Sprite();
		screenEntity.addChild(goalTitleEntity.add(goalTitleSprite));
		
		var goalInfoEntity: Entity = new Entity();
		var goalInfoBg: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height * 0.25);
		goalInfoBg.centerAnchor();
		goalInfoBg.setXY(System.stage.width / 2, System.stage.height / 2);
		goalInfoEntity.addChild(new Entity().add(goalInfoBg));
		
		var goalInfoFont: Font = new Font(gameAssets, AssetName.FONT_UNCERTAIN_SANS_32);
		var goalInfoText: TextSprite = new TextSprite(goalInfoFont, "Info");
		goalInfoText.centerAnchor();
		goalInfoText.setXY(goalInfoBg.x._, goalInfoBg.y._);
		goalInfoEntity.addChild(new Entity().add(goalInfoText));
		
		goalInfoSprite = new Sprite();
		screenEntity.addChild(goalInfoEntity.add(goalInfoSprite));
		
		var screenScript: Script = new Script();
		screenScript.run(new Sequence([
			new Delay(screenDuration),
			new CallFunction(function() {
				HideScreen();
			})
		]));
		
		screenEntity.addChild(new Entity().add(screenScript));
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_GOAL;
	}
	
	override public function ShowScreen():Void 
	{
		goalTitleSprite.x._ = -System.stage.width;
		goalInfoSprite.y._ = -System.stage.height;
		
		var showScript: Script = new Script();
		showScript.run(new Parallel([
			new AnimateTo(goalTitleSprite.x, 0, 1, Ease.backInOut),
			new AnimateTo(goalInfoSprite.y, 0, 1, Ease.backInOut)
		]));
		
		screenEntity.addChild(new Entity().add(showScript));
	}
	
	override public function HideScreen():Void 
	{
		screenBackground.alpha._ = 0.5;
		goalTitleSprite.x._ = 0;
		goalInfoSprite.y._ = 0;
		
		var hideScript: Script = new Script();
		hideScript.run(new Sequence([
			new Parallel([
				new AnimateTo(screenBackground.alpha, 0, 0.5),
				new AnimateTo(goalTitleSprite.x, System.stage.width, 0.5, Ease.backIn),
				new AnimateTo(goalInfoSprite.y, System.stage.height, 0.5, Ease.backIn)
			]),
			new CallFunction(function() {
				SceneManager.current.UnwindToScene(SceneManager.curSceneEntity);
			})
		]));
		
		screenEntity.addChild(new Entity().add(hideScript));
	}
}