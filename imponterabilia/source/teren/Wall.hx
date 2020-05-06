package teren;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Wall extends FlxSprite
{
    override public function new(x_pos:Int, y_pos:Int)
        {
            super(x_pos, y_pos);
            makeGraphic(500, 15, FlxColor.BROWN);

            immovable = true;
        }
}