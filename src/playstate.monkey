Strict

Import flixel
Import flixel.flxtext.driver.angelfont
Import src.astronaut
Import src.progressbar
Import src.alonegame

Class PlayState Extends FlxState

	Global CLASS_OBJECT:FlxClass = New PlayStateClass()
	
	Const SPACESHIP_SPEED:Float = 10
	Const PIXELS_PER_KM:Int = 20	
	
	Field astronaut:Astronaut
	Field gas:ProgressBar
	Field oxygen:ProgressBar
	Field nitro:ProgressBar
	Field distance:FlxText
	
Private
	Field _bg:Image[3]
	Field _bgScroll:Float
	
	Field _cameraBound:FlxRect
	
	Field _distancePassed:Float
	Field _spaceshipDistancePassed:Float	

	Field _cylinders:FlxGroup
Public	
	Method Create:Void()	
		_cameraBound = New FlxRect(100, 400, 600, 0)
	
		Local bg:Image = LoadImage("gfx/bg.jpg")
		_bg[0] = bg
		_bg[1] = bg
		_bg[2] = bg
	
		astronaut = New Astronaut()
		Add(astronaut)		
		
		oxygen = New ProgressBar(10, FlxG.DEVICE_HEIGHT - 30, AloneGame.OXYGEN_COLOR)
		Add(oxygen)
		
		gas = New ProgressBar(FlxG.DEVICE_WIDTH / 2 - ProgressBar.WIDTH / 2, FlxG.DEVICE_HEIGHT - 30, AloneGame.GAS_COLOR)
		Add(gas)
		
		nitro = New ProgressBar(FlxG.DEVICE_WIDTH - ProgressBar.WIDTH - 10, FlxG.DEVICE_HEIGHT - 30, AloneGame.NITRO_COLOR)
		nitro.value = 0
		Add(nitro)
		
		distance = New FlxText(10, 10, FlxG.DEVICE_WIDTH - 20, "", New FlxTextAngelFontDriver())
		distance.SetFormat("orbitrton", 28, FlxG.WHITE, FlxText.ALIGN_RIGHT)
		Add(distance)
		
		_cylinders = New FlxGroup()
		
		
		
		_spaceshipDistancePassed = 1000
	End Method
	
	Method Update:Void()
		Super.Update()
		
		oxygen.value = astronaut.oxygen
		gas.value = astronaut.gas
		
		_distancePassed += astronaut.speed.y / PIXELS_PER_KM
		_spaceshipDistancePassed += SPACESHIP_SPEED / PIXELS_PER_KM
				
		_bgScroll -= astronaut.speed.y*.9
		If (Abs(_bgScroll) >  _bg[0].Height()) _bgScroll = 0
		
		astronaut.x = Clamp(astronaut.x, _cameraBound.Left, _cameraBound.Right)
		astronaut.y = Clamp(astronaut.y, _cameraBound.Top, _cameraBound.Bottom)
		
		distance.Text = "Distance: " + Ceil(_spaceshipDistancePassed + _distancePassed)  + " km"
		
		If (astronaut.speed.y <> 0) Then
			FlxG.camera.Shake(-astronaut.speed.y / 5000, 0.1)
		End If
	End Method
	
	Method Draw:Void()		
		DrawImage(_bg[0], 0, _bgScroll)
		DrawImage(_bg[1], 0, _bgScroll - _bg[0].Height())
		DrawImage(_bg[2], 0, _bgScroll + _bg[0].Height())

		Super.Draw()		
	End Method
	
End Class

Class PlayStateClass Implements FlxClass
	
	Method CreateInstance:FlxBasic()
		Return New PlayState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (PlayState(object) <> Null)
	End Method

End Class