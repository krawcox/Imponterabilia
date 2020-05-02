package przeciwnicy;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import postacie.Hero;
import bronie.Miecz;

class Walker extends Potwor
{
    public static var WIDTH(default, never):Int = 32;
    public static var HEIGHT(default, never):Int = 32;

    public static var SPEED(default, never):Float = 100;

    public var zasieg:Int = 150;
    public var start_x:Int;
    public var start_y:Int;

    public var miecz:Miecz;
    public var hero_nearby:Bool = false;
    public var prepared:Bool = false;
    public var atak_countdown:Int;
    public var attack_deley:Int = -1;
    public var miecz_x:Float;
    public var miecz_y:Float;

    override public function new(x_pos, y_pos)
        {
            super(x_pos, y_pos);
            start_x = x_pos;
            start_y = y_pos;
            makeGraphic(WIDTH, HEIGHT, FlxColor.RED);
            health = 3;
            velocity.x = SPEED;
            facing = FlxObject.RIGHT;
        }
    public function moveDirection()
        {
            if(x >= start_x + zasieg)
                {
                   velocity.x = SPEED * -1;
                   facing = FlxObject.LEFT;
                }
            else if(x <= start_x - zasieg)
                {
                    velocity.x = SPEED;
                    facing = FlxObject.RIGHT;
                }
        }
    public function kolor()
        {
            if(!wrazliwy)
            {
                replaceColor(FlxColor.RED, FlxColor.YELLOW);
            }
            else {
                replaceColor(FlxColor.YELLOW, FlxColor.RED);
            }
        }
    private function chechHero()
        {
            var hero:Hero = (cast FlxG.state).bohater;
            if(hero.x + hero.width > start_x - zasieg || hero.x < start_x + zasieg)
                {
                    hero_nearby = true;
                    if(hero.x  < x)
                        {
                            velocity.x = SPEED * -1;
                            facing = FlxObject.LEFT;
                        }
                    else if(hero.x > x)
                        {
                            velocity.x = SPEED;
                            facing = FlxObject.RIGHT;
                        }
                    else 
                        {
                            velocity.x = 0;
                        }
                }
            else
                {
                    hero_nearby = false;
                }
        }
    private function prepare()
        {
            if(hero_nearby)
                {
                    var hero:Hero = (cast FlxG.state).bohater;
                    if(hero.x + hero.width >= x - 15 &&  hero.x <= x + width + 15)
                        {
                            velocity.x = 0;
                            if(hero.x + hero.width <= x + width/2)
                                {
                                    facing = FlxObject.LEFT;
                                }
                            else if(hero.x > x + width/2)
                                {
                                    facing = FlxObject.RIGHT;
                                }
                            if(prepared)
                                {
                                    atak_countdown--;
                                }
                            else 
                                {
                                    prepared = true;
                                    atak_countdown = 30;
                                }
                        }
                }
        }
    private function atak()
        {
            if(atak_countdown == 0)
                {
                    if(facing == FlxObject.RIGHT)
                        {
                            miecz = new Miecz(x + width, y + height/2, FlxColor.ORANGE, FlxObject.RIGHT);
                        }
                    else if(facing == FlxObject.LEFT)
                        {
                            miecz = new Miecz(x, y + height/2, FlxColor.ORANGE, FlxObject.LEFT);
                        }
                    
                    FlxG.state.add(miecz);
                    atak_countdown = 45;
                    attack_deley = 30;
                }
            else 
                {
                    if(attack_deley == 0)
                        {
                            miecz.kill();
                        }
                    else if(attack_deley > 0)
                        {
                            attack_deley--;
                            if(facing == FlxObject.RIGHT)
                                {
                                    miecz_x = x + width;
                                }
                            else if(facing == FlxObject.LEFT)
                                {
                                    miecz_x = x - 25;
                                }
                            miecz_y = y + height/2;
                            miecz.x = miecz_x;
                            miecz.y = miecz_y;
                        }
                }
        }
    override public function update(elapsed:Float)
        {
            moveDirection();
            kolor();
            chechHero();
            prepare();
            atak();
            super.update(elapsed);
        }
}