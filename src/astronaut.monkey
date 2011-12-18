Strict

Import flixel
Import src.playstate
Import src.progressbar

Class Astronaut Extends FlxSprite

	Const SENSITIVITY:Float = 2
	Const MAX_ACCELERATE:Float = 5
	Const NITRO_ACCELERATE:Float = 20
	Const FRICTION:Float = 0.03
	Const MAX_ANGLE:Float = 130
	Const MIN_ANGLE:Float = 50

	Field angle:Float
	Field accelerate:Float
	Field speed:FlxPoint
	
	Field oxygen:Float = ProgressBar.MAX_VALUE
	Field gas:Float = ProgressBar.MAX_VALUE
	
Private
	Field _sprite:Image
	Field _nitroSprite:Image
	
	Field _nitroTime:Float
	
Public	
	Method New()
		_sprite = LoadImage("gfx/astronaut.png", 1, Image.MidHandle)
		_nitroSprite = LoadImage("gfx/nitro.png", 1, Image.MidHandle)

		x = FlxG.DEVICE_WIDTH / 2
		y = FlxG.DEVICE_HEIGHT - 150	
		width = _sprite.Width()
		height = _sprite.Height()	
		
		angle = 90
		speed = New FlxPoint()		
	End Method
	
	Method Update:Void()	
		If (KeyDown(KEY_LEFT) Or KeyDown(KEY_A)) Then
			angle += SENSITIVITY
		End If
		
		If (KeyDown(KEY_RIGHT) Or KeyDown(KEY_D)) Then
			angle -= SENSITIVITY		
		End If
		
		angle = Clamp(angle, MIN_ANGLE, MAX_ANGLE)
		
		accelerate -= FRICTION
		
		If (KeyDown(KEY_SPACE)) Then
			_nitroTime += FlxG.elapsed / 5		
			accelerate = Min(accelerate + _nitroTime, NITRO_ACCELERATE)
			gas -= FlxG.elapsed / 50
		Else
			_nitroTime = 0
		End If
		
		If (KeyDown(KEY_N)) Then
			accelerate = NITRO_ACCELERATE
		End If
		
		accelerate = Max(accelerate, 0.0)
		
		speed.x = Cos(-angle) * accelerate
		speed.y = Sin(-angle) * accelerate
		
		x += speed.x
		y += speed.y
		
		oxygen -= FlxG.elapsed / 100
	End Method
	
	Method Draw:Void()
		PushMatrix()
			Translate(x, y)
			Rotate(angle)
			DrawImage(_sprite, 0, 0)
			If (_nitroTime > 0) Then
				Scale(1 + .05 * Sin(_nitroTime * 5000), 1)
				DrawImage(_nitroSprite, -34, -3)
			End if
		PopMatrix()
	End Method

End Class