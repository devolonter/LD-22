Strict

Import flixel
Import src.playstate
Import src.progressbar
Import src.collisions

Class Astronaut Extends FlxSprite

	Const SENSITIVITY:Float = 2
	Const MAX_ACCELERATE:Float = 5
	Const NITRO_ACCELERATE:Float = 15
	Const FRICTION:Float = 0.03
	Const MAX_ANGLE:Float = 130
	Const MIN_ANGLE:Float = 50
		
	'Чем меньше чем больше расход
	Const NITRO_CONSUMPTION:Float = 5
	Const GAS_CONSUMPTION:Float = 50
	Const OXYGEN_CONSUMPTION:Float = 70

	Field angle:Float
	Field accelerate:Float
	Field gasAccelerate:Float
	Field nitroAccelerate:Float
	Field speed:FlxPoint
	
	Field oxygen:Float = ProgressBar.MAX_VALUE
	Field health:Float = ProgressBar.MAX_VALUE
	Field nitro:Float = 0
	
Private
	Field _sprite:Image
	Field _gasSprite:Image
	
	Field _jetpackSound:Sound
	Field _jetpackNitroSound:Sound
	Field _jetpackSoundPlaying:Bool = False
	
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
		
		If (jetpackSound = Null) Then
			jetpackSound = LoadSound("sfx/jetpack.mp3")
			jetpackNitroSound = LoadSound("sfx/jetpack_nitro.mp3")	
		End If
		
		_jetpackSound = jetpackSound
		_jetpackNitroSound = jetpackNitroSound
		SetChannelVolume(PlayState.NITRO_CHANNEL, .9)
		
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
			
			
			If (Not _jetpackSoundPlaying And nitro <= 0) Then
				PlaySound(_jetpackSound, PlayState.JETPACK_CHANNEL, 1)
				_jetpackSoundPlaying = True
			End If
		Else				
			StopChannel(PlayState.JETPACK_CHANNEL)		
			_jetpackSoundPlaying = False
			gasAccelerate = 0
			_gasForce = 0
		End If
		
		If (nitro > 0) Then
			nitroAccelerate = NITRO_ACCELERATE
			
			If (nitro = 1) Then
				PlaySound(_jetpackNitroSound, PlayState.NITRO_CHANNEL)	
			End If
			
			nitro = Max(nitro - FlxG.elapsed / NITRO_CONSUMPTION, 0.0)
		Else
			StopChannel(PlayState.NITRO_CHANNEL)			
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
	Global jetpackSound:Sound
	Global jetpackNitroSound:Sound