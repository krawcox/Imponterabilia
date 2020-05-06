package bronie;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Fireball extends FlxSprite
{
    public static var WIDTH(default, never):Int = 6;
    public static var HEIGHT(default, never):Int = 6;
    public static var DLUGOSC(default, never):Int = 150;
    public static var SPEED(default, never):Float = 150;
    public static var REF_RATE(default, never):Int = 20;

    public var predkosc:Float;
    public var zywotnosc:Int = DLUGOSC;

    private var cel_x:Float;
    private var cel_y:Float;

    private var reflect_rate:Int;

    private var able_to_reflect:Bool = true;

    override public function new(x_pos, y_pos)
        {
            super(x_pos, y_pos);
            makeGraphic(WIDTH, HEIGHT, FlxColor.RED);
            reflect_rate = -1;
        }
    public function ustaw_cel(x_pos:Float, y_pos:Float) 
        {
            cel_x = x_pos;
            cel_y = y_pos;
            velocity.x = cel_x - x;
            velocity.y = cel_y - y;
        }
    public function ustaw_zywotnosc()
        {
            zywotnosc = DLUGOSC;
        }
    public function reflect()
        {
            if(able_to_reflect)
                {
                    velocity.x = -2 * velocity.x;
                    velocity.y = -2 * velocity.y;
                    zywotnosc = DLUGOSC;
                    able_to_reflect = false;
                    reflect_rate = REF_RATE;
                }
        }
    public function reflectionRate()
        {
            if(!able_to_reflect)
                {
                    reflect_rate--;
                }
            if(reflect_rate == 0)
                {
                    able_to_reflect = true;
                }
        }
    public function egzystuje()
        {
            if(zywotnosc == 0)
                {
                    kill();
                }
            else if(alive)
                {
                    zywotnosc--;
                }
        }
    public function kierunek()
        {
            if(velocity.x >= 0)
                {
                    facing = FlxObject.RIGHT;
                }
            else if(velocity.x < 0)
                {
                    facing = FlxObject.LEFT;
                }
        }
    override public function update(elapsed:Float)
        {
            egzystuje();
            kierunek();
            reflectionRate();
            super.update(elapsed);
        }
}