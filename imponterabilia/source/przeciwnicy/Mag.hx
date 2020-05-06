package przeciwnicy;

import postacie.Hero;
import utility.Zdrowie;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import przeciwnicy.Potwor;
import bronie.Fireball;

class Mag extends Potwor
{
    public static var WIDTH(default, never):Int = 32;
    public static var HEIGHT(default, never):Int = 32;

    public static var SPEED(default, never):Float = 75;

    public static var ZASIEG(default,never):Int = 65;
    public static var ZASIEG_WIDZENIA(default,never):Int = 150;

    public static var FIREBALL_LIMIT(default,never):Int = 3;


    private var start_x:Int;
    private var start_y:Int;

    private var able_to_attack:Bool = false;
    private var atak_deley:Int = -1;
    private var hero_nearby:Bool;
    public var health_bar:FlxTypedGroup<Zdrowie>;
    private var zycie:Int;
    public var fireballs:FlxTypedGroup<Fireball>;

    override public function new(x_pos, y_pos)
        {
            super(x_pos, y_pos);
            makeGraphic(WIDTH, HEIGHT, FlxColor.GREEN);
            velocity.x = SPEED;
            start_x = x_pos;
            start_y = y_pos;
            health = 2;
            zycie = 2;
            facing = FlxObject.RIGHT;
            health_bar = new FlxTypedGroup<Zdrowie>();
            var licznik:Int = 0;
            for(i in 0...zycie)
                {
                    var serduszko:Zdrowie = new Zdrowie(x_pos + licznik, y - 15);
                    health_bar.insert(i ,serduszko);
                    licznik += 10;
                }
            FlxG.state.add(health_bar);
            fireballs = new FlxTypedGroup<Fireball>(FIREBALL_LIMIT);
            for(i in 0...FIREBALL_LIMIT)
                {
                    var kula:Fireball = new Fireball(0, 0);
                    kula.kill();
                    fireballs.insert(i, kula);
                }
        }
    private function move()
        {
            if(hero_nearby)
                {
                    velocity.x = 0;
                    velocity.y = 0;
                }
            else if(x == start_x + ZASIEG)
                {
                    if(y < start_y + ZASIEG && y > start_y - ZASIEG && velocity.y < 0)
                        {
                            velocity.y = -SPEED;
                            velocity.x = 0;
                        }
                    else if(y < start_y + ZASIEG && y > start_y - ZASIEG && velocity.y >= 0)
                        {
                            velocity.x = 0;
                            velocity.y = SPEED;
                        }
                    else if((y == start_y + ZASIEG || y == start_y - ZASIEG) && velocity.x == 0)
                        {
                            velocity.y = 0;
                            velocity.x = -SPEED;
                        }
                    else if((y == start_y + ZASIEG || y == start_y - ZASIEG) && velocity.y == 0)
                        {
                            velocity.x = 0;
                            if(y == start_y + ZASIEG)
                                {
                                    velocity.y = -SPEED;
                                    facing = FlxObject.LEFT;
                                }
                            else 
                                {
                                    velocity.y = SPEED;
                                    facing = FlxObject.RIGHT;
                                }
                        }
                }
            else if(x == start_x - ZASIEG)
                {
                    if(y < start_y + ZASIEG && y > start_y - ZASIEG && velocity.y < 0)
                        {
                            velocity.y = -SPEED;
                            velocity.x = 0;
                        }
                    else if(y < start_y + ZASIEG && y > start_y - ZASIEG && velocity.y >= 0)
                        {
                            velocity.x = 0;
                            velocity.y = SPEED;
                        }
                    else if((y == start_y + ZASIEG || y == start_y - ZASIEG) && velocity.x == 0)
                        {
                            velocity.y = 0;
                            velocity.x = SPEED;
                        }
                    else if((y == start_y + ZASIEG || y == start_y - ZASIEG) && velocity.y == 0)
                        {
                            velocity.x = 0;
                            if(y == start_y + ZASIEG)
                                {
                                    velocity.y = -SPEED;
                                    facing = FlxObject.LEFT;
                                }
                            else 
                                {
                                    velocity.y = SPEED;
                                    facing = FlxObject.RIGHT;
                                }
                            }
                }
            else if((y == start_y + ZASIEG || y == start_y - ZASIEG) && velocity.x == 0)
                {
                    if(facing == FlxObject.RIGHT)
                        {
                            velocity.x = SPEED;
                        }
                    else if(facing == FlxObject.LEFT)
                        {
                            velocity.x = -SPEED;
                        }
                }
        }
    private function checkHero()
        {
            var bohater = (cast FlxG.state).bohater;
            if(bohater.x + bohater.width > x - ZASIEG_WIDZENIA && bohater.x + bohater.width <= x + WIDTH/2 && (bohater.y + bohater.height >= y - ZASIEG_WIDZENIA && bohater.y <= y + ZASIEG_WIDZENIA))
                {
                    hero_nearby = true;
                    facing = FlxObject.LEFT;
                }
            else if(bohater.x < x + ZASIEG_WIDZENIA && bohater.x > x + WIDTH/2 && (bohater.y + bohater.height >= y - ZASIEG_WIDZENIA && bohater.y <= y + ZASIEG_WIDZENIA))
                {
                    hero_nearby = true;
                    facing = FlxObject.RIGHT;
                }
            else
                {
                    hero_nearby = false;
                }
        }
    override public function hit()
        {
            if(wrazliwy)
                {
                    health--;
                    countdown = 120;
                    wrazliwy = false;
                    var serduszko = health_bar.getFirstAlive();
                    serduszko.kill();
                }
        }
    private function ruch(przedmiot:FlxObject)
        {
            przedmiot.velocity.x = velocity.x;
            przedmiot.velocity.y = velocity.y;
        }
    private function health_bar_move()
        {
            health_bar.forEach(ruch);
        }
    private function atak()
        {
            if(hero_nearby && able_to_attack)
                {
                    var bohater:Hero = (cast FlxG.state).bohater;
                    if(bohater.x + bohater.width/2 <= x || bohater.x + bohater.width/2 >= x + width)
                        {
                            if(fireballs.countLiving() != FIREBALL_LIMIT)
                                {
                                    var fireball:Fireball = fireballs.getFirstDead();
                                    if(facing == FlxObject.LEFT)
                                        {
                                            fireball.x = x - 6;
                                            fireball.y = y + HEIGHT/2;
                                        }
                                    else if(facing == FlxObject.RIGHT)
                                        {
                                            fireball.x = x + WIDTH;
                                            fireball.y = y + HEIGHT/2;
                                          }
                                    fireball.revive();
                                    fireball.ustaw_cel(bohater.x + bohater.width/2, bohater.y + bohater.height/2);
                                    fireball.ustaw_zywotnosc();
                                    FlxG.state.add(fireball);
                                    able_to_attack = false;
                                    atak_deley = -1;
                                }
                    }
                }
            else if(hero_nearby)
                {
                    if(atak_deley == 0)
                        {
                            able_to_attack = true;
                        }
                    else if(atak_deley == -1)
                        {
                            atak_deley = 30;
                        }
                    else if(atak_deley <= 30 && atak_deley > 0)
                        {
                            atak_deley--;
                        }
                }
        }
    override public function update(elapsed:Float)
        {
            checkHero();
            move();
            health_bar_move();
            atak();
            super.update(elapsed);
        }
}