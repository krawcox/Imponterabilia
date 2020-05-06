package przeciwnicy;

import bronie.Miecz;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Potwor extends FlxSprite
{
    
    public var wrazliwy:Bool = true;
    public var countdown:Int = -1;

    override public function new(x_pos:Int, y_pos:Int)
        {
            super(x_pos, y_pos);
        }
    public function hit()
        {
            if(wrazliwy)
                {
                    health--;
                    countdown = 120;
                    wrazliwy = false;
                }
        }

    override public function update(elapsed:Float)
        {
            if(countdown == 0)
                {
                    wrazliwy = true;
                    countdown = -1;
                }
            else
                {
                    countdown--;
                }
            super.update(elapsed);
        }
    
}