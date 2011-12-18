Strict

Import flixel
Import flixel.flxtext.driver.angelfont
Import src.astronaut
Import src.progressbar
Import src.alonegame
Import src.cylinder
Import src.bigasteroid

Class PlayState Extends FlxState

	Global CLASS_OBJECT:FlxClass = New PlayStateClass()
	
	Const SPACESHIP_SPEED:Float = 5
	Const PIXELS_PER_KM:Int = 20
	Const NITRO_PERIOD:Float = 2
	Const NITRO_NEEDED_SPEED:Float = Astronaut.MAX_ACCELERATE - 1
	Const ASTEROIDS_PERIOD:Float = 1
	Const ASTEROID_NEEDED_SPEED:Float = Astronaut.MAX_ACCELERATE - 1	
	
	Field astronaut:Astronaut
	Field gas:ProgressBar
	Field oxygen:ProgressBar
	Field nitro:ProgressBar
	Field distance:FlxText
	
Private
	Field _bg:Image[3]
	Field _bgScroll:Float
	
	Field _cameraBound:FlxRect
	Field _collisionsBound:FlxRect
	
	Field _distancePassed:Float
	Field _spaceshipDistancePassed:Float	

	Field _cylinders:FlxGroup
	Field _tmpCylinder:Cylinder
	Field _elapsedNitroTime:Float
	
	Field _bigAsteroids:FlxGroup
	Field _tmpBigAsteroid:BigAsteroid
	Field _elpasedBigAsteroidTime:Float
	
	Field _gameStarted:Bool = False
	
Public	
	Method Create:Void()	
		_cameraBound = New FlxRect(100, 450, 600, 0)
	
		If (bgSprite = Null) Then
			bgSprite = LoadImage("gfx/bg.jpg")
		Endif
		
		_bg[0] = bgSprite
		_bg[1] = bgSprite
		_bg[2] = bgSprite			
		
		distance = New FlxText(10, 10, FlxG.DEVICE_WIDTH - 20, "", New FlxTextAngelFontDriver())
		distance.SetFormat("orbitrton", 28, FlxG.WHITE, FlxText.ALIGN_RIGHT)
		Add(distance)
		
		_cylinders = New FlxGroup()
		Add(_cylinders)
		
		_GenerateCylinder(FlxG.DEVICE_WIDTH / 2, 200, Cylinder.TYPE_NITRO)
		
		_bigAsteroids = New FlxGroup()
		Add(_bigAsteroids)
		
		_GenerateBigAsteroid(Rnd(_cameraBound.Left, _cameraBound.Right), -200)
		
		
		astronaut = New Astronaut()
		Add(astronaut)
		
		_collisionsBound = New FlxRect(0, _cameraBound.y - astronaut.width / 2, FlxG.DEVICE_WIDTH, astronaut.width)
		
		oxygen = New ProgressBar(10, FlxG.DEVICE_HEIGHT - 30, AloneGame.OXYGEN_COLOR)
		Add(oxygen)
		
		gas = New ProgressBar(FlxG.DEVICE_WIDTH / 2 - ProgressBar.WIDTH / 2, FlxG.DEVICE_HEIGHT - 30, AloneGame.GAS_COLOR)
		Add(gas)
		
		nitro = New ProgressBar(FlxG.DEVICE_WIDTH - ProgressBar.WIDTH - 10, FlxG.DEVICE_HEIGHT - 30, AloneGame.NITRO_COLOR)
		nitro.value = 0
		Add(nitro)
		
		_spaceshipDistancePassed = 50000
	End Method
	
	Method Update:Void()
		Super.Update()
		
		oxygen.value = astronaut.oxygen
		gas.value = astronaut.gas
		nitro.value = astronaut.nitro		
		
		_distancePassed += astronaut.speed.y / PIXELS_PER_KM
		_spaceshipDistancePassed += SPACESHIP_SPEED / PIXELS_PER_KM
				
		_bgScroll -= astronaut.speed.y*.3
		If (Abs(_bgScroll) >  _bg[0].Height()) _bgScroll = 0
		
		astronaut.x = Clamp(astronaut.x, _cameraBound.Left, _cameraBound.Right)
		astronaut.y = Clamp(astronaut.y, _cameraBound.Top, _cameraBound.Bottom)
		
		For Local cylinder:FlxBasic = EachIn _cylinders
			_tmpCylinder = Cylinder(cylinder)
			
			If (_tmpCylinder <> Null And _tmpCylinder.alive) Then
				_tmpCylinder.y -= astronaut.speed.y
				If (_tmpCylinder.y + _tmpCylinder.height > _collisionsBound.Top And _tmpCylinder.y < _collisionsBound.Bottom) Then
					If (Collision.PolyToPoly(astronaut.GetCollisionMask(), _tmpCylinder.GetCollisionMask())) Then
						_tmpCylinder.Kill()
						astronaut.nitro = ProgressBar.MAX_VALUE
						_elapsedNitroTime = NITRO_PERIOD
						_gameStarted = True	
					End If
				End If
				
				If (_tmpCylinder.y > FlxG.DEVICE_HEIGHT) Then
					_tmpCylinder.Kill()
					_gameStarted = True	
				End If
			End If
				
		Next
		
		_elapsedNitroTime -= FlxG.elapsed
		
		For Local bigAteroid:FlxBasic = EachIn _bigAsteroids
			_tmpBigAsteroid = BigAsteroid(bigAteroid)
			
			If (_tmpBigAsteroid <> Null And _tmpBigAsteroid.alive) Then
				_tmpBigAsteroid.y -= astronaut.speed.y
				
				If (_tmpBigAsteroid.y > FlxG.DEVICE_HEIGHT) Then
					_tmpBigAsteroid.Kill()
					_gameStarted = True	
				End If
			End If
				
		Next
				
		If (_gameStarted And _elapsedNitroTime <= 0) Then
			If (Abs(astronaut.speed.y) > NITRO_NEEDED_SPEED) Then
				_GenerateCylinder(Rnd(_cameraBound.Left, _cameraBound.Right), -100, Cylinder.TYPE_NITRO)				
			End If
			
			_elapsedNitroTime = NITRO_PERIOD
		End If
		
		_elpasedBigAsteroidTime -= FlxG.elapsed
		
		If (_gameStarted And _elpasedBigAsteroidTime <= 0) Then
			If (Abs(astronaut.speed.y) > ASTEROID_NEEDED_SPEED) Then
				_GenerateBigAsteroid(Rnd(_cameraBound.Left, _cameraBound.Right), -100)				
			End If
		
			_elpasedBigAsteroidTime = ASTEROIDS_PERIOD
		End If
		
		distance.Text = "Distance: " + Ceil(_spaceshipDistancePassed + _distancePassed)  + " km"
		
		If (astronaut.speed.y <> 0) Then
			FlxG.camera.Shake(-astronaut.speed.y / 3000, 0.1)
		End If
	End Method
	
	Method Draw:Void()		
		DrawImage(_bg[0], 0, _bgScroll)
		DrawImage(_bg[1], 0, _bgScroll - _bg[0].Height())
		DrawImage(_bg[2], 0, _bgScroll + _bg[0].Height())
		
		#If CONFIG="debug"
			DrawRect(_collisionsBound.Left, _collisionsBound.Top, _collisionsBound.width, _collisionsBound.height)
		#End

		Super.Draw()		
	End Method

Private	
	Method _GenerateCylinder:Void(x:Float, y:Float, type:Int)
		_tmpCylinder = Cylinder(_cylinders.Recycle(Cylinder.CLASS_OBJECT))
		_tmpCylinder.SetPos(x, y)
		_tmpCylinder.Type = type
		_tmpCylinder.Revive()
	End Method
	
	Method _GenerateBigAsteroid:Void(x:Float, y:Float)
		_tmpBigAsteroid = BigAsteroid(_bigAsteroids.Recycle(BigAsteroid.CLASS_OBJECT))
		_tmpBigAsteroid.SetPos(x, y)
		_tmpBigAsteroid.SetType(Rnd(0, 5))
		_tmpBigAsteroid.Revive()
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

Private
	Global bgSprite:Image