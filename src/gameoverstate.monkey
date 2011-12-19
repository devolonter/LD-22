Strict

Import flixel
Import src.playstate

Class GameOverState Extends FlxState

	Global CLASS_OBJECT:FlxClass = New GameOverClass()
	
Private
	Field _astroCorpse:Image

	Field _distance:String = ""
	Field _reason:Int
	
	Field _title:FlxText
	Field _distanceText:FlxText
	Field _reasonText:FlxText
	Field _tip:FlxText
	
	Method New(distance:String, reason:Int) 
		_distance = distance
		_reason = reason 
	End Method
	
	Method Create:Void()		
		_title = New FlxText(40,  30, FlxG.DEVICE_WIDTH - 80, AloneGame.GAME_OVER, New FlxTextAngelFontDriver())
		_title.SetFormat(AloneGame.FONT_TECHNIQUE, 48,  AloneGame.HEALTH_COLOR, FlxText.ALIGN_CENTER)
		Add(_title)
		
		_distanceText = New FlxText(20,  150, FlxG.DEVICE_WIDTH - 40, _distance + AloneGame.KM_LEFT, New FlxTextAngelFontDriver())
		_distanceText.SetFormat(AloneGame.FONT_ORBITRON, 24, FlxG.WHITE, FlxText.ALIGN_CENTER)
		Add(_distanceText)
		
		_reasonText = New FlxText(20,  200, FlxG.DEVICE_WIDTH - 40, "", New FlxTextAngelFontDriver())
		Add(_reasonText)
		
		Select (_reason)
			Case 0
				_reasonText.Text = AloneGame.OXYGEN_OVER
				_reasonText.SetFormat(AloneGame.FONT_ORBITRON, 24, AloneGame.OXYGEN_COLOR, FlxText.ALIGN_CENTER)
			Case 1
				_reasonText.Text = AloneGame.HEALTH_OVER
				_reasonText.SetFormat(AloneGame.FONT_ORBITRON, 24, AloneGame.HEALTH_COLOR, FlxText.ALIGN_CENTER)	
		End Select
		
		_tip = New FlxText(40,  FlxG.DEVICE_HEIGHT - 70, FlxG.DEVICE_WIDTH - 80, AloneGame.GAME_OVER_TIP, New FlxTextAngelFontDriver())
		_tip.SetFormat(AloneGame.FONT_ORBITRON, 24, FlxG.WHITE, FlxText.ALIGN_CENTER)
		Add(_tip)
		
		_astroCorpse = LoadImage("gfx/astro_corpse.png", 1, Image.MidHandle)
		
	End Method
	
	Method Update:Void()
		Super.Update()
	
		If (KeyHit(KEY_ENTER)) Then
			FlxG.SwitchState(New PlayState(PlayState.FROM_GAME_OVER))
		End If
	End Method
	
	Method Draw:Void()
		DrawImage(_astroCorpse, FlxG.DEVICE_WIDTH / 2, FlxG.DEVICE_HEIGHT / 2 + 100)
		
		Super.Draw()
	End Method
	
	Method Destroy:Void()
		Super.Destroy()

		_astroCorpse.Discard()
		_astroCorpse = Null
	End Method

End Class

Class GameOverClass Implements FlxClass
	
	Method CreateInstance:FlxBasic()
		Return New GameOverState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (GameOverState(object) <> Null)
	End Method

End Class