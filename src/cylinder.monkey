Strict

Import flixel

Class Cylinder Extends FlxSprite
	
	Const TYPE_OXYGEN:Int = 0
	Const TYPE_GAS:Int = 1
	Const TYPE_NITRO:Int = 2
	
	Global CLASS_OBJECT:FlxClass = New CylinderClass()
	
Private
	Field _sprite:Image
	Field _frame:Int
	Field _collisionsPoly:Float[]
	
Public
	Method New(x:Float = 0, y:Float = 0, type:Int = TYPE_NITRO)
		_sprite = LoadImage("gfx/cylinders.png", TYPE_NITRO + 1)
		
		SetX(x)
		SetY(y)
				
		Type = type		
	End Method
	
	Method Draw:Void()
		DrawImage(_sprite, x, y, _frame)
	End Method
	
	Method Type:Int() Property
		Return _frame
	End Method	
	
	Method Type:Void(type:Int) Property
		_frame = Clamp(type, TYPE_OXYGEN, TYPE_NITRO)
	End Method
	
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

End Class

Class CylinderClass Implements FlxClass
	
	Method CreateInstance:FlxBasic()
		Return New Cylinder()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (Cylinder(object) <> Null)
	End Method
 
End Class