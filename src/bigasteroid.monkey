Strict

Import src.asteroid

Class BigAsteroid Extends Asteroid

	Global CLASS_OBJECT:FlxClass = new BigAsteroidClass()
	
	Method New(x:Float, y:Float)			
		If (bigAsteroidsSprites[0] = Null) Then
			For Local i:Int = 0 Until 6
				bigAsteroidsSprites[i] = LoadImage("gfx/asteroids/big/"+ (i+1) +".png")
			Next
		End if
		
		SetType(Rnd(0, 5))
		SetPos(x, y)					
	End Method
	
	Method SetType:Void(type:Int)
		Self._sprite = bigAsteroidsSprites[type]
		
		#Rem
			Select type
				Case 0
						
			End Select
		#End
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