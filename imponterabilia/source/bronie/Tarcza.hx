package bronie;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxObject;

class Tarcza extends FlxSprite
{
    public static var WIDTH(default, never):Int = 10;
    public static var HEIGHT(default, never):Int = 32;

    override public function new(x_pos:Float, y_pos:Float, facing:Int)
        {
            if(facing == FlxObject.RIGHT)
                {
                    super(x_pos, y_pos);
                }
            else if(facing == FlxObject.LEFT)
                {
                    super(x_pos - WIDTH, y_pos);
                }
            makeGraphic(WIDTH, HEIGHT, FlxColor.GREEN);   
        }
}