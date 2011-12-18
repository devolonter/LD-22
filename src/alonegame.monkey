Strict

Import flixel
Import playstate

Class AloneGame Extends FlxGame

	Const OXYGEN_COLOR:Int = $ff0097ff
	Const GAS_COLOR:Int = $ffbe0000
	Const NITRO_COLOR:Int = $ff62be00

	Method New()
		Super.New(800, 600, PlayState.CLASS_OBJECT)
	End Method
	
	Method OnContentInit:Void()	
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		
		Local system:FlxFont = FlxAssetsManager.AddFont(FlxText.SYSTEM_FONT, FlxText.DRIVER_ANGELFONT)
		
		For Local i:Int = minSize To maxSize
			system.SetPath(i, "fonts/" + FlxText.SYSTEM_FONT + "/angelfont/"+i+".txt")	
		Next
	
		Local orbitron:FlxFont = FlxAssetsManager.AddFont("orbitrton", FlxText.DRIVER_ANGELFONT)		
		orbitron.SetPath(28, "fonts/orbitron_28.txt")
	End Method
	
End Class