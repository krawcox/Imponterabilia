package utility;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Zdrowie extends FlxSprite
{
    public static var WIDTH(default, never):Int = 10;
    public static var HEIGHT(default, never):Int = 10;

    override public function new(x_pos, y_pos)
        {
            super(x_pos, y_pos);
            makeGraphic(WIDTH, HEIGHT, FlxColor.RED);
        }

}