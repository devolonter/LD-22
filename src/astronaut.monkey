Strict

Import flixel
Import src.playstate
Import src.progressbar
Import src.collisions

Class Astronaut Extends FlxSprite

	Const SENSITIVITY:Float = 2
	Const MAX_ACCELERATE:Float = 5
	Const NITRO_ACCELERATE:Float = 10
	Const FRICTION:Float = 0.03
	Const MAX_ANGLE:Float = 130
	Const MIN_ANGLE:Float = 50
	
	'Чем меньше чем больше расход
	Const NITRO_CONSUMPTION:Float = 5
	Const GAS_CONSUMPTION:Float = 50
	Const OXYGEN_CONSUMPTION:Float = 100

	Field angle:Float
	Field accelerate:Float
	Field gasAccelerate:Float
	Field nitroAccelerate:Float
	Field speed:FlxPoint
	
	Field oxygen:Float = ProgressBar.MAX_VALUE
	Field gas:Float = ProgressBar.MAX_VALUE
	Field nitro:Float = 0
	
Private
	Field _sprite:Image
	Field _gasSprite:Image
	
	Field _collisionsPoly:Float[]
	
	Field _gasForce:Float	
	
Public	
	Method New()
		#If CONFIG = "debug"
			Print "New instance of astronaut"
		#End
	
		If (astronautSprite = Null) Then
			#If CONFIG = "debug"
				Print "Astronaut images load"
			#End
		
			astronautSprite = LoadImage("gfx/astronaut.png", 1, Image.MidHandle)
			gasSprite = LoadImage("gfx/gas.png", 1, Image.MidHandle)
		End if
		
		_sprite	= astronautSprite
		_gasSprite = gasSprite
		
		x = (FlxG.DEVICE_WIDTH / 2)
		y = (FlxG.DEVICE_HEIGHT - 150)
		width = _sprite.Width()
		height = _sprite.Height()	
		
		angle = 90
		speed = New FlxPoint()
		
		_collisionsPoly = [0.0, 18.0, 35.0, 0.0, 105.0, 10.0, 116.0, 36.0, 110.0, 60.0, 35.0, 80.0, 0.0, 56.0]	
	End Method
	
	Method Update:Void()	
		If (KeyDown(KEY_LEFT) Or KeyDown(KEY_A)) Then
			angle += SENSITIVITY
		End If
		
		If (KeyDown(KEY_RIGHT) Or KeyDown(KEY_D)) Then
			angle -= SENSITIVITY		
		End If
		
		angle = Clamp(angle, MIN_ANGLE, MAX_ANGLE)
		
		accelerate = Max(accelerate - FRICTION, 0.0)
		
		If (KeyDown(KEY_SPACE)) Then
			_gasForce += FlxG.elapsed / 10		
			gasAccelerate = Min(gasAccelerate + _gasForce, MAX_ACCELERATE)
			gas = Max(gas - FlxG.elapsed / GAS_CONSUMPTION, 0.0)
		Else
			gasAccelerate = 0
			_gasForce = 0
		End If
		
		If (nitro > 0) Then
			nitroAccelerate = NITRO_ACCELERATE
			nitro = Max(nitro - FlxG.elapsed / NITRO_CONSUMPTION, 0.0)
		Else	
			nitroAccelerate = 0	
		End If
		
		If (gasAccelerate > 0 Or nitroAccelerate > 0) Then
			accelerate = Clamp(gasAccelerate + nitroAccelerate, accelerate, MAX_ACCELERATE + NITRO_ACCELERATE)
		End If
		
		speed.x = Cos(-angle) * accelerate
		speed.y = Sin(-angle) * accelerate
		
		x += speed.x
		y += speed.y
		
		oxygen = Max(oxygen - FlxG.elapsed / OXYGEN_CONSUMPTION, 0.0)		
	End Method
	
	Method Draw:Void()
		#If CONFIG="debug"
			SetColor(0, 0, 255)	
			DrawPoly(Collision.TFormPoly(_collisionsPoly, x, y, angle, 1, 1, _sprite.HandleX(), _sprite.HandleY()))
			SetColor(255, 255, 255)
		#End		
			
		PushMatrix()
			Translate(x, y)			
			Rotate(angle)			
			DrawImage(_sprite, 0, 0)
			If (_gasForce > 0 Or nitro > 0) Then
				Scale(1 + .05 * Sin(_gasForce * 5000), 1)
				DrawImage(_gasSprite, -34, -3)
			End if
		PopMatrix()				
	End Method
	
	Method GetCollisionMask:Float[]()
		Return Collision.TFormPoly(_collisionsPoly, x, y, angle, 1, 1, _sprite.HandleX(), _sprite.HandleY())		
	End Method

End Class

Private
	Global astronautSprite:Image
	Global gasSprite:Image