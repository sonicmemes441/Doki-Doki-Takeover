package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class LangSelectState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = [];
	var localeList:Array<String> = [];

	var curSelected:Int = 0;

	var backdrop:FlxBackdrop;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	override function create()
	{
		add(backdrop = new FlxBackdrop(Paths.image('scrolling_BG')));
		backdrop.velocity.set(-40, -40);

		var languageList:Array<String> = CoolUtil.coolTextFile(Paths.txt('locale/languageList'));

		for (i in 0...languageList.length)
		{
			var data:Array<String> = languageList[i].split(':');
			textMenuItems.push(data[0]);
			localeList.push(data[1]);
		}

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(0, 20 + (i * 50), 0, textMenuItems[i], 32);
			optionText.setFormat("Riffic Free Bold", 32, FlxColor.WHITE, CENTER);
			optionText.screenCenter(X);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectedSomethin)
		{
			if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected -= 1;
				}
		
				if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected += 1;
				}
		
				if (curSelected < 0)
					curSelected = textMenuItems.length - 1;
		
				if (curSelected >= textMenuItems.length)
					curSelected = 0;
		
				grpOptionsTexts.forEach(function(txt:FlxText)
				{
					txt.setBorderStyle(OUTLINE, 0xFFFF7CFF, 2);
		
					if (txt.ID == curSelected)
						txt.setBorderStyle(OUTLINE, 0xFFFFCFFF, 2);
				});
		
				if (controls.ACCEPT)
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					grpOptionsTexts.forEach(function(txt:FlxText)
						{
							if (curSelected != txt.ID)
							{
								FlxTween.tween(txt, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
									txt.kill();
									}
								});
								}
								else
							{
									if (FlxG.save.data.flashing)
								{
									FlxFlicker.flicker(txt, 1, 0.06, false, false, function(flick:FlxFlicker)
										{
											FlxG.save.data.language = localeList[curSelected];
											trace('langauge set to ' + FlxG.save.data.language);
											FlxG.switchState(new MainMenuState());
									});
									}
								else
								{
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										FlxG.save.data.language = localeList[curSelected];
										trace('langauge set to ' + FlxG.save.data.language);
										FlxG.switchState(new MainMenuState());
									});
								}
							}
						});
				}
		}
	}
}