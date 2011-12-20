Strict

Import flixel
Import src.titlestate

Class AloneGame Extends FlxGame	

	Const OXYGEN_COLOR:Int = $ff0097ff
	Const HEALTH_COLOR:Int = $ffbe0000
	Const NITRO_COLOR:Int = $ff62be00
	
	Const NAME:String = "STAND ALONE"
	Const TITLE:String = "REACH YOUR SPACESHIP"
	Const COPYRIGHT:String = "BY DEVOLONTER & AHNINNIAH"
	Const TITLE_TIP:String = "PRESS ENTER TO START"
	Const GAME_OVER_TIP:String = "PRESS ENTER TO RESTART"
	Const GAME_OVER:String = "GAME OVER"
	Const KM_LEFT:String = " LEFT TO REACH YOUR SPACESHIP"
	Const OXYGEN_OVER:String = "YOUR OXYGEN IS OVER"
	Const HEALTH_OVER:String = "YOUR INJURIES ARE INCOMPATIBLE WITH LIFE"
	Const YOU_WIN:String = "YOU WIN!"
	Const WIN_TIP:String = "PRESS ENTER TO GO TITLE SCREEN"
	Const START_TIP:String = "HOLD SPACE TO ACCELERATE"
	
	Const FONT_ORBITRON:String = "orbitron"
	Const FONT_TECHNIQUE:String = "technique"
	
Public
	Method New()
		Super.New(800, 600, TitleState.CLASS_OBJECT)
	End Method
		
	Method OnContentInit:Void()	
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		
		Local system:FlxFont = FlxAssetsManager.AddFont(FlxText.SYSTEM_FONT, FlxText.DRIVER_ANGELFONT)
		
		For Local i:Int = minSize To maxSize
			system.SetPath(i, "fonts/" + FlxText.SYSTEM_FONT + "/angelfont/"+i+".txt")	
		Next
	
		Local orbitron:FlxFont = FlxAssetsManager.AddFont(FONT_ORBITRON, FlxText.DRIVER_ANGELFONT)		
		orbitron.SetPath(28, "fonts/orbitron_28.txt")
		orbitron.SetPath(24, "fonts/orbitron_24.txt")
		orbitron.SetPath(16, "fonts/orbitron_16.txt")
		
		Local technique:FlxFont = FlxAssetsManager.AddFont(FONT_TECHNIQUE, FlxText.DRIVER_ANGELFONT)
		technique.SetPath(48, "fonts/technique_48.txt")		
	End Method
	
	Function GetBgSprite:Image()
		If (bgSprite = Null) Then
			#If CONFIG="debug"
				Print "Background image loaded"
			#End
			bgSprite = LoadImage("gfx/bg.jpg")
		Endif
		
		Return bgSprite
	End Function
	
End Class

Private
	Global bgSprite:Image