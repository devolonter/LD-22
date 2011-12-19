Strict

Import flixel
Import flixel.flxtext.driver.angelfont

Import src.alonegame
Import src.playstate

Class TitleState Extends FlxState

	Global CLASS_OBJECT:FlxClass = New TitleStateClass()

Private
	Field _bg:Image
	Field _titleAstro:Image
	Field _titleAsteroid:Image
	Field _title:FlxText
	Field _subTitle:FlxText
	Field _copyright:FlxText
	Field _tip:FlxText

	Method Create:Void()
		_bg = AloneGame.GetBgSprite()
		
		_title = New FlxText(40,  FlxG.DEVICE_HEIGHT / 2, FlxG.DEVICE_WIDTH - 80, AloneGame.NAME, New FlxTextAngelFontDriver())
		_title.SetFormat(AloneGame.FONT_TECHNIQUE, 48, AloneGame.OXYGEN_COLOR)
		Add(_title)
		
		_subTitle = New FlxText(300,  FlxG.DEVICE_HEIGHT / 2 + 60, 400, AloneGame.TITLE, New FlxTextAngelFontDriver())
		_subTitle.SetFormat(AloneGame.FONT_ORBITRON, 16)
		Add(_subTitle)
		
		_copyright = New FlxText(20,  20, FlxG.DEVICE_WIDTH - 40, AloneGame.COPYRIGHT, New FlxTextAngelFontDriver())
		_copyright.SetFormat(AloneGame.FONT_ORBITRON, 16, FlxG.WHITE, FlxText.ALIGN_RIGHT)
		Add(_copyright)
		
		_tip = New FlxText(20,  FlxG.DEVICE_HEIGHT - 100, 550, AloneGame.TITLE_TIP, New FlxTextAngelFontDriver())
		_tip.SetFormat(AloneGame.FONT_ORBITRON, 24, FlxG.WHITE, FlxText.ALIGN_CENTER)
		Add(_tip)
		
		_titleAstro = LoadImage("gfx/title_astro.png")
		_titleAsteroid = LoadImage("gfx/title_asteroid.png")
				
		PlayMusic("sfx/intro.mp3")
		SetMusicVolume(.8)
	End Method
	
	Method Update:Void()
		Super.Update()
	
		If (KeyHit(KEY_ENTER)) Then
			FlxG.SwitchState(New PlayState())
		End If
		
		#If TARGET <> "flash" And TARGET <> "html5"
			If (KeyHit(KEY_ESCAPE)) Then
				Error ""
			End If
		#End
	End Method
	
	Method Draw:Void()
		DrawImage(_bg, 0, 0)
		DrawImage(_titleAstro, 500, 220)
		DrawImage(_titleAsteroid, 200, 50)
		
		Super.Draw()
	End Method
	
	Method Destroy:Void()
		Super.Destroy()

		_titleAsteroid.Discard()
		_titleAstro.Discard()
		
		_bg = Null
		_titleAstro = Null
		_titleAsteroid = Null
		StopMusic()
	End Method
	
End Class

Class TitleStateClass Implements FlxClass
	
	Method CreateInstance:FlxBasic()
		Return New TitleState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (TitleState(object) <> Null)
	End Method

End Class