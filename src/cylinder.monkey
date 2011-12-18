Strict

Import flixel

Class Cylinder Extends FlxSprite
	
	Const TYPE_OXYGEN:Int = 0
	Const TYPE_GAS:Int = 1
	Const TYPE_NITRO:Int = 2
	
Private
	Field _sprite:Image
	Field _frame:Int
	Field _collisionsPoly:Float[]
	
Public
	Method New(x:Float, y:Float, type:Int = TYPE_NITRO)
		_sprite = LoadImage("gfx/cylinders.png", TYPE_NITRO + 1)
		
		Self.x = x -_sprite.Width() / 2
		Self.y = y -_sprite.Height() / 2
		
		_frame = type		
	End Method
	
	Method Draw:Void()
		DrawImage(_sprite, x, y, _frame)
	End Method

End Class