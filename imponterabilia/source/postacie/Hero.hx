package postacie;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import bronie.Miecz;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import utility.Zdrowie;
import bronie.Tarcza;

class Hero extends FlxSprite {
    public static var WIDTH(default, never):Int = 32;
    public static var HEIGHT(default, never):Int = 32;

    public static var MIECZ_WIDTH(default, never):Int = 32;

    public static var GRAVITY(default, never):Float = 300;
    public static var TERMINAL_VELOCITY(default, never):Float = 600;
    public static var X_SPEED(default, never):Float = 200;
    public static var PUSHBACK_X(default, never):Float = 200;
    public static var PUSHBACK_Y(default, never):Float = -100;

    public static var SWORD_HEIGHT(default, never):Float = 13;
    public static var SWORD_WIDTH(default, never):Float = 32;


    public static var JUMP_SPEED(default, never):Float = -200;

    public var allow_to_jump:Bool = true;
    public var skoki_dostepne:Int = 2;

    public var attack_deley:Int = -1;
    public var attacking:Bool = false;   

    private var leftInput:Bool = false;
    private var rightInput:Bool = false;
    private var jumpInput:Bool = false;
    private var atakInput:Bool = false;
    private var obronaInput:Bool = false;

    private var direction:Int;
    private var push_back_side:Int;

    private var health_bar:FlxTypedGroup<Zdrowie>;

    private var x_pos:Float;
    private var y_pos:Float;

    public var miecz:Miecz;
    public var tarcza:Tarcza;

    public var wrazliwy:Bool = true;
    public var countdown:Int = -1;


    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
        makeGraphic(WIDTH, HEIGHT, FlxColor.WHITE);
        acceleration.y = GRAVITY;
        maxVelocity.y = TERMINAL_VELOCITY;
        miecz = new Miecz(x + width, y + height/2, FlxColor.MAGENTA, FlxObject.RIGHT);
        miecz.kill();
        tarcza = new Tarcza(x + WIDTH, y + HEIGHT, FlxObject.RIGHT);
        tarcza.kill();
        allow_to_jump = true;
        health = 5;
        var zycie:Int = 5;
        health_bar = new FlxTypedGroup<Zdrowie>();
        var licznik = 10;
        for(i in 0...zycie)
            {
                var serduszko = new Zdrowie(X - FlxG.camera.width/2 + 20 + licznik, Y - FlxG.camera.height/2 + 10);
                licznik += 10;
                health_bar.insert(i, serduszko);
            }
        FlxG.state.add(health_bar);
    }

    override function update(elapsed:Float) {
        gatherInputs();
        direction = getMoveDirectionCoefficient(leftInput, rightInput);
        if(this.isTouching(FlxObject.DOWN))
            {
                allow_to_jump = true;
                skoki_dostepne = 2;
            }
        jump(jumpInput);
        super.update(elapsed);
        move();
        obrona(obronaInput);
        atak(atakInput);
        zraniony();
        health_bar_move();
    }

    private function gatherInputs()
    {
        leftInput = FlxG.keys.pressed.LEFT;
        rightInput = FlxG.keys.pressed.RIGHT;
        atakInput = FlxG.keys.justPressed.W;
        obronaInput = FlxG.keys.pressed.Q;
        jumpInput = FlxG.keys.justPressed.SPACE;
    }

    private function getMoveDirectionCoefficient(leftPressed:Bool, rightPressed:Bool):Int {
        var finalDirection:Int = 0;        
        if (leftPressed) {
            finalDirection--;
        }
        if (rightPressed) {
            finalDirection++;
        }
        if(finalDirection == 1)
            {
                facing = FlxObject.RIGHT;
            }
        else if(finalDirection == -1)
            {
                facing = FlxObject.LEFT;
            }
        return finalDirection;
    }

    private function jump(jumpJustPressed:Bool):Void {
        if(allow_to_jump){

        if (jumpJustPressed) {
            velocity.y = JUMP_SPEED;
            skoki_dostepne--;
            if(skoki_dostepne == 0)
                {
                    allow_to_jump = false;
                }
            }
        }
    }
    private function obrona(obronaInput:Bool)
        {
            if(obronaInput)
                {
                    if(!tarcza.alive)
                        {
                            tarcza.revive();
                            FlxG.state.add(tarcza);
                        }
                    if(facing == FlxObject.RIGHT)
                        {
                            tarcza.x = x + width + 3;
                            tarcza.y = y;
                        }
                    else if(facing == FlxObject.LEFT)
                        {
                            tarcza.x = x - tarcza.width - 3;
                            tarcza.y = y;
                        }
                }
            else if(tarcza.alive)
                {
                    tarcza.kill();
                }
        }
    private function atak(atakInput:Bool)
        {
        if(atakInput == true && attack_deley == -1 && obronaInput == false)
            {
                attacking = true;
                attack_deley = 20;
                if(facing == FlxObject.RIGHT)
                    {
                        miecz = new Miecz(x + width, y + height/2, FlxColor.MAGENTA, FlxObject.RIGHT);
                    }
                else if(facing == FlxObject.LEFT)
                    {
                        miecz = new Miecz(x, y + height/2, FlxColor.MAGENTA, FlxObject.LEFT);
                    }
                
                FlxG.state.add(miecz);
            }
        else 
            {
                if(attack_deley == 0 && miecz.alive)
                    {
                        attacking = false;
                        miecz.kill();
                        attack_deley = -1;
                    }
                else if(attack_deley > 0)
                    {
                        attack_deley--;
                        if(facing == FlxObject.RIGHT)
                            {
                                x_pos = x + width;
                            }
                        else if(facing == FlxObject.LEFT)
                            {
                                x_pos = x - miecz.width;
                            }
                        y_pos = y + height/2;
                        miecz.x = x_pos;
                        miecz.y = y_pos;
                    }
            }
        }
    private function move()
        {
            if(!wrazliwy && countdown > 15)
                {
                    if(push_back_side == FlxObject.RIGHT)
                        {
                            velocity.x = PUSHBACK_X;
                        }
                    else if(push_back_side == FlxObject.LEFT)
                        {
                            velocity.x = -PUSHBACK_X;
                        }
                }
            else 
                {
                    velocity.x = X_SPEED * direction;
                }
        }
    public function trafiony(strona:Int)
        {
            if(wrazliwy)
                {
                    health--;
                    countdown = 30;
                    wrazliwy = false;
                    var serduszko = health_bar.getFirstAlive();
                    serduszko.kill();
                    push_back_side = strona;
                }
        }
    public function zraniony()
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
        }
    private function health_bar_move()
        {
            health_bar.forEach(ruch);
        }
    private function ruch(przedmiot:FlxObject) {
        przedmiot.velocity.x = velocity.x;
        przedmiot.y = y - FlxG.camera.height/2 + 20;
    }
}