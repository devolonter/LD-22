Strict

Import src.asteroid

Class BigAsteroid Extends Asteroid

	Const MIN_TYPE:Int = 5
	Const MAX_TYPE:Int = 5

	Global CLASS_OBJECT:FlxClass = new BigAsteroidClass()
	
	Method New(x:Float, y:Float)
		#If CONFIG = "debug"
			Print "New instance of big asteroid"
		#End
				
		If (bigAsteroidsSprites[0] = Null) Then
			#If CONFIG = "debug"
				Print "Big asteroid images load"
			#End
			
			For Local i:Int = 0 Until MAX_TYPE + 1
				bigAsteroidsSprites[i] = LoadImage("gfx/asteroids/big/"+ (i+1) +".png")
			Next
			
			collisionsMasks[0] = [0.0, 58.0, 7.0, 32.0, 34.0, 13.0, 82.0, 0.0, 113.0, 9.0, 133.0, 31.0, 137.0, 48.0, 128.0, 85.0, 105.0, 104.0, 36.0, 101.0, 11.0, 84.0]
	
			collisionsMasks[1] = [0.0, 52.0, 5.0, 29.0, 29.0, 11.0, 55.0, 1.0, 94.0, 4.0, 147.0, 3.0, 173.0, 27.0, 177.0, 45.0, 173.0, 64.0, 155.0, 81.0, 119.0, 96.0, 84.0, 105.0, 62.0, 106.0, 20.0, 92.0, 5.0, 74.0]
	
			collisionsMasks[2] = [0.0, 43.0, 4.0, 29.0, 20.0, 18.0, 64.0, 3.0, 89.0, 0.0, 101.0, 3.0, 114.0, 19.0, 118.0, 35.0, 113.0, 50.0, 99.0, 65.0, 86.0, 70.0, 57.0, 69.0, 28.0, 75.0, 17.0, 72.0, 2.0, 53.0]
	
			collisionsMasks[3] = [0.0, 88.0, 3.0, 75.0, 26.0, 18.0, 49.0, 3.0, 68.0, 0.0, 91.0, 10.0, 103.0, 25.0, 108.0, 56.0, 107.0, 88.0, 91.0, 121.0, 68.0, 134.0, 43.0, 136.0, 14.0, 117.0, 2.0, 101.0]
	
			collisionsMasks[4] = [0.0, 49.0, 7.0, 25.0, 25.0, 6.0, 70.0, 0.0, 90.0, 3.0, 139.0, 28.0, 170.0, 55.0, 174.0, 77.0, 168.0, 97.0, 136.0, 118.0, 90.0, 107.0, 49.0, 103.0, 20.0, 85.0, 3.0, 65.0]
	
			collisionsMasks[5] = [0.0, 87.0, 7.0, 58.0, 21.0, 23.0, 33.0, 5.0, 47.0, 0.0, 65.0, 6.0, 77.0, 20.0, 78.0, 31.0, 70.0, 56.0, 69.0, 89.0, 59.0, 106.0, 37.0, 117.0, 18.0, 113.0, 2.0, 97.0]
		End if		
		
		SetType(Rnd(0, MAX_TYPE))
		SetPos(x, y)
		width = _sprite.Width()
		height = _sprite.Height()					
	End Method
	
	Method SetType:Void(type:Int)
		Self._sprite = bigAsteroidsSprites[type]
		Self._collisionsPoly = collisionsMasks[type]
	End Method

End Class

Class BigAsteroidClass Implements FlxClass
	
	Method CreateInstance:FlxBasic()
		Return New BigAsteroid(0, 0)
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (BigAsteroid(object) <> Null)
	End Method
 
End Class

Private
	Global bigAsteroidsSprites:Image[6]
	Global collisionsMasks:Float[BigAsteroid.MAX_TYPE + 1][]	