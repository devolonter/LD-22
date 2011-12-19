Strict

Import flixel
Import src.collisions

Class Asteroid Extends FlxSprite

	Field collided:Bool = False

	Field _sprite:Image
	Field _collisionsPoly:Float[]	
	
	Method SetX:Void(x:Float)
		Self.x = x -_sprite.Width() / 2	
	End Method
	
	Method SetY:Void(y:Float)
		Self.y = y -_sprite.Height() / 2
	End Method
	
	Method SetPos:Void(x:Float, y:Float)
		SetX(x)
		SetY(y)
	End Method
	
	Method Draw:Void()		
		DrawImage(_sprite, x, y)
		
		#If CONFIG="debug"
			PushMatrix()
				Translate(x, y)
				SetColor(0, 0, 255)			
				DrawPoly(_collisionsPoly)
				SetColor(255, 255, 255)
			PopMatrix()
		#End	
	End Method
		
	Method GetCollisionMask:Float[]()
		Return Collision.TFormPoly(_collisionsPoly, x, y, 0, 1, 1, 0, 0)
	End Method
	
	Method Revive:Void()
		Super.Revive()
		collided = False	
	End Method

End Class