Strict

Import flixel
Import src.collisions

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
		#If CONFIG = "debug"
			Print "New instance of cylinder"
		#End
	
		If (cylindersSprites = Null) Then		
			#If CONFIG = "debug"
				Print "Cylinder images load"
			#End
		
			cylindersSprites = LoadImage("gfx/cylinders.png", TYPE_NITRO + 1)
		End If
		
		_sprite = cylindersSprites
		
		width = _sprite.Width()
		height = _sprite.Height()
				
		SetX(x)
		SetY(y)
						
		Type = type
		_collisionsPoly = [0.0, 0.0, _sprite.Width(), 0.0, _sprite.Width(), _sprite.Height(), 0.0, _sprite.Height()]		
	End Method
	
	Method Draw:Void()
		#If CONFIG="debug"
			PushMatrix()
				Translate(x, y)
				SetColor(0, 0, 255)			
				DrawPoly(_collisionsPoly)
				SetColor(255, 255, 255)
			PopMatrix()
		#End
	
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
	
	Method GetCollisionMask:Float[]()
		Return Collision.TFormPoly(_collisionsPoly, x, y, 0, 1, 1, 0, 0)
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

Private
	Global cylindersSprites:Image