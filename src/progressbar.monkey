Strict

Import flixel
Import flixel.flxtext.driver.angelfont
Import src.alonegame

Class ProgressBar extends FlxGroup

	Const MIN_VALUE:Int = 0
	Const MAX_VALUE:Float = 1
	Const WIDTH:Int = 150
	Const HEIGHT:Int = 20
	
	Field value:Float
	Field color:FlxColor
	Field border:Int = 2
	Field width:Float
	Field height:Float
	Field x:Float
	Field y:Float
	
Private
	Field _title:FlxText
	
Public
	Method New(x:Float, y:Float, title:String, color:Int)
		width = WIDTH
		height = HEIGHT
		
		Self.x = x
		Self.y = y
		
		value = MAX_VALUE
		
		Self.color = New FlxColor(color)
		
		_title = New FlxText(x, y - HEIGHT, WIDTH, title, New FlxTextAngelFontDriver())
		_title.SetFormat(AloneGame.FONT_ORBITRON, 16, color)
		Add(_title)
	End Method
	
	Method Draw:Void()
		Super.Draw()
	
		SetColor(color.r, color.g, color.b)
		DrawRect(x, y, width, height)
		SetColor(0, 0, 0)
		DrawRect(x + border, y + border, width - border * 2, height - border * 2)
		SetColor(color.r, color.g, color.b)
		DrawRect(x + border * 2, y + border * 2, (width - border * 4) * value, height - border * 4)
		SetColor(255, 255, 255)		
	End Method

End Class