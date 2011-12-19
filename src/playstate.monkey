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
	
	Const SPACESHIP_SPEED:Float = Astronaut.MAX_ACCELERATE + 3
	Const PIXELS_PER_KM:Int = 20
	Const NITRO_PERIOD:Float = Astronaut.NITRO_CONSUMPTION - 1
	Const NITRO_NEEDED_SPEED:Float = Astronaut.MAX_ACCELERATE - 1
	Const ASTEROIDS_PERIOD:Float = 3
	Const ASTEROID_NEEDED_SPEED:Float = Astronaut.MAX_ACCELERATE - 1
	Const START_DISTANCE:Float = 1000	
	Const ASTEROID_DAMAGE:Float = .1
	
	Const JETPACK_CHANNEL:Int = 0
	Const NITRO_CHANNEL:Int = 1
	Const CYLINDER_CHANNEL:Int = 2
	Const ASTEROID_CHANNEL:Int = 3
	
	Field astronaut:Astronaut
	Field health:ProgressBar
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
	
	Field _cylinderSound:Sound
	Field _asteroidSound:Sound
	
Public	
	Method Create:Void()	
		_cameraBound = New FlxRect(100, 450, 600, 0)
	
		If (bgSprite = Null) Then
			bgSprite = LoadImage("gfx/bg.jpg")
		Endif
		
		_bg[0] = bgSprite
		_bg[1] = bgSprite
		_bg[2] = bgSprite
		
		If (cylinderSound = Null) Then
			cylinderSound = LoadSound("sfx/get_cylinder.mp3")
			asteroidSound = LoadSound("sfx/asteroid_hit.mp3")			
		End If
		
		_cylinderSound = cylinderSound
		SetChannelVolume(CYLINDER_CHANNEL, .4)
		
		_asteroidSound = asteroidSound
		
		distance = New FlxText(10, 10, FlxG.DEVICE_WIDTH - 20, "", New FlxTextAngelFontDriver())
		distance.SetFormat("orbitrton", 28, FlxG.WHITE, FlxText.ALIGN_RIGHT)
		Add(distance)
		
		_cylinders = New FlxGroup()
		Add(_cylinders)
		
		_GenerateCylinder(FlxG.DEVICE_WIDTH / 2, 200, Cylinder.TYPE_NITRO)
		
		_bigAsteroids = New FlxGroup()
		Add(_bigAsteroids)
		
		_GenerateBigAsteroid()		
		
		astronaut = New Astronaut()
		Add(astronaut)
		
		_collisionsBound = New FlxRect(0, _cameraBound.y - astronaut.width / 2, FlxG.DEVICE_WIDTH, astronaut.width)
		
		oxygen = New ProgressBar(10, FlxG.DEVICE_HEIGHT - 30, AloneGame.OXYGEN_COLOR)
		Add(oxygen)
		
		health = New ProgressBar(FlxG.DEVICE_WIDTH / 2 - ProgressBar.WIDTH / 2, FlxG.DEVICE_HEIGHT - 30, AloneGame.GAS_COLOR)
		Add(health)
		
		nitro = New ProgressBar(FlxG.DEVICE_WIDTH - ProgressBar.WIDTH - 10, FlxG.DEVICE_HEIGHT - 30, AloneGame.NITRO_COLOR)
		nitro.value = 0
		Add(nitro)
		
		_spaceshipDistancePassed = START_DISTANCE
		
		PlayMusic("sfx/main_theme.mp3")
		SetMusicVolume(.7)
	End Method
	
	Method Update:Void()
		Super.Update()				
		
		_distancePassed -= astronaut.speed.y / PIXELS_PER_KM
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
						_elpasedBigAsteroidTime = 0
						PlaySound(_cylinderSound, CYLINDER_CHANNEL)	
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
				
				If (_tmpBigAsteroid.y + _tmpBigAsteroid.height > _collisionsBound.Top And _tmpBigAsteroid.y < _collisionsBound.Bottom) Then
					If (Collision.PolyToPoly(astronaut.GetCollisionMask(), _tmpBigAsteroid.GetCollisionMask())) Then
						If (astronaut.x > _tmpBigAsteroid.x + _tmpBigAsteroid.width / 2) Then
							If (_cameraBound.Right - (_tmpBigAsteroid.x + _tmpBigAsteroid.width) > astronaut.height) Then
								astronaut.x += astronaut.accelerate
							Else
								astronaut.x -= astronaut.accelerate
							End If
						Else
							If (_tmpBigAsteroid.x - _cameraBound.Left > astronaut.height) Then
								astronaut.x -= astronaut.accelerate
							Else
								astronaut.y += astronaut.accelerate	
							End If
						End if						
						
						If (Not _tmpBigAsteroid.collided) Then
							FlxG.camera.Flash($77FF0000, 0.5)
							astronaut.health -= ASTEROID_DAMAGE
							PlaySound(_asteroidSound, ASTEROID_CHANNEL)	
						End If
						
						_tmpBigAsteroid.collided = True						
					End If						
				End If
				
				If (_tmpBigAsteroid.y > FlxG.DEVICE_HEIGHT) Then
					_tmpBigAsteroid.Kill()
					_gameStarted = True	
				End If
			End If
				
		Next
				
		If (_gameStarted And _elapsedNitroTime <= 0) Then
			If (Abs(astronaut.speed.y) > NITRO_NEEDED_SPEED) Then
				_GenerateCylinder(Rnd(_cameraBound.Left, _cameraBound.Right), Rnd(-10, -50), Cylinder.TYPE_NITRO)				
			End If
			
			_elapsedNitroTime = NITRO_PERIOD
		End If
		
		_elpasedBigAsteroidTime -= FlxG.elapsed
		
		If (_gameStarted And _elpasedBigAsteroidTime <= 0) Then
			If (Abs(astronaut.speed.y) > ASTEROID_NEEDED_SPEED) Then
				_GenerateBigAsteroid()				
			End If
		
			_elpasedBigAsteroidTime = ASTEROIDS_PERIOD + (astronaut.speed.y / 7) - (START_DISTANCE / (_spaceshipDistancePassed - _distancePassed))*.1
			_elpasedBigAsteroidTime = Max(_elpasedBigAsteroidTime, .5) 
		End If
		
		oxygen.value = astronaut.oxygen
		health.value = astronaut.health
		nitro.value = astronaut.nitro
		
		distance.Text = "Distance: " + Ceil(_spaceshipDistancePassed - _distancePassed)  + " km"
		
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
	
	Method _GenerateBigAsteroid:Void()
		
		
		_tmpBigAsteroid = BigAsteroid(_bigAsteroids.Recycle(BigAsteroid.CLASS_OBJECT))
		_tmpBigAsteroid.SetPos(Rnd(_cameraBound.Left, _cameraBound.Right), Rnd(-300, -400))
		_tmpBigAsteroid.SetType(Rnd(0, BigAsteroid.MAX_TYPE))
		_tmpBigAsteroid.Revive()
		_elpasedBigAsteroidTime = ASTEROIDS_PERIOD
		
		If (Not _gameStarted) _tmpBigAsteroid.Kill()	
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
	Global cylinderSound:Sound
	Global asteroidSound:Sound