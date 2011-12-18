Strict

Import flixel

Class ProgressBar extends FlxSprite

	Const MIN_VALUE:Int = 0
	Const MAX_VALUE:Float = 1
	Const WIDTH:Int = 150
	Const HEIGHT:Int = 20
	
	Field value:Float
	Field color:FlxColor
	Field border:Int = 2 
	
	Method New(x:Float, y:Float, color:Int)
		width = WIDTH
		height = HEIGHT
		
		Self.x = x
		Self.y = y
		
		value = MAX_VALUE
		
		Self.color = New FlxColor(color)	
	End Method
	
	Method Draw:Void()
		SetColor(color.r, color.g, color.b)
		DrawRect(x, y, width, height)
		SetColor(0, 0, 0)
		DrawRect(x + border, y + border, width - border * 2, height - border * 2)
		SetColor(color.r, color.g, color.b)
		DrawRect(x + border * 2, y + border * 2, (width - border * 4) * value, height - border * 4)
		SetColor(255, 255, 255)		
	End Method

End Class