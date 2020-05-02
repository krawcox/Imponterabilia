package bronie;


import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import postacie.Hero;
import flixel.FlxG;

class Miecz extends FlxSprite
{
    private static var WIDTH(default, never):Int = 25;
    private static var HEIGHT(default, never):Int = 12;

    override public function new(x_pos:Float, y_pos:Float, color:FlxColor, facing:Int)
        {  
            if(facing == FlxObject.RIGHT)
            {
                super(x_pos, y_pos);
            }
            else if(facing == FlxObject.LEFT)
                {
                    super(x_pos - WIDTH, y_pos);
                }
            makeGraphic(WIDTH, HEIGHT,color);
        }
    public function hitAnything(przedmiot:FlxSprite):Void
        {
            przedmiot.health--;
        }
    public function zyje(){
        var zycie:Bool;
        if(alive)
            {
                zycie = true;
            }
        else
            {
                zycie = false;
            }
        return zycie;
    }
    
}