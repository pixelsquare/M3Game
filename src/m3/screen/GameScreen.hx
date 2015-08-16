package m3.screen;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.scene.Scene;
import flambe.System;
import flambe.display.Font;
import flambe.display.TextSprite;

import m3.core.GameData;
import m3.pxlSq.Utils;
import m3.names.AssetName;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameScreen
{
	public var screenEntity(default, null): Entity;
	
	private var gameAssets: AssetPack;
	private var screenScene: Scene;
	private var screenDisposer: Disposer;
	
	private var screenBackground: FillSprite;
	private var screenTitleText: TextSprite;
	
	public function new() {	
		gameAssets = GameData.current != null ? GameData.current.gameAssets : null;
	}
	
	public function CreateScreen(): Entity {
		screenEntity = new Entity()
			.add(screenScene = new Scene(false));
			
		screenDisposer = new Disposer()
			.add(screenEntity);
			
		screenBackground = new FillSprite(0xFFFFFF, System.stage.width, System.stage.height);
		screenEntity.addChild(new Entity().add(screenBackground));
		
		var titleFont: Font = new Font(gameAssets, AssetName.FONT_VANADINE_32);
		screenTitleText = new TextSprite(titleFont, GetScreenName());
		screenTitleText.centerAnchor();
		screenTitleText.setXY(System.stage.width / 2, System.stage.height * 0.3);
		screenEntity.addChild(new Entity().add(screenTitleText));
			
		return screenEntity;
	}
	
	public function GetScreenName(): String {
		return "";
	}
	
	public function ShowScreen(): Void { }
	
	public function HideScreen(): Void { }
	
	private function RemoveTitleScreen(): Void {
		screenEntity.removeChild(new Entity().add(screenTitleText));
	}
}