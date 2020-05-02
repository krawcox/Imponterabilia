package postacie;

import flixel.FlxObject;
import bronie.Miecz;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;


class Hero extends FlxSprite {
    public static var WIDTH(default, never):Int = 32;
    public static var HEIGHT(default, never):Int = 32;

    public static var MIECZ_WIDTH(default, never):Int = 32;

    public static var GRAVITY(default, never):Float = 300;
    public static var TERMINAL_VELOCITY(default, never):Float = 600;
    public static var X_SPEED(default, never):Float = 200;

    public static var SWORD_HEIGHT(default, never):Float = 13;
    public static var SWORD_WIDTH(default, never):Float = 32;

    public static var JUMP_SPEED(default, never):Float = -200;

    public var allow_to_jump:Bool = true;

    public var attack_deley:Int = -1;
    public var attacking:Bool = false;   

    private var leftInput:Bool = false;
    private var rightInput:Bool = false;
    private var jumpInput:Bool = false;
    private var atakInput:Bool = false;

    private var x_pos:Float;
    private var y_pos:Float;

    public var miecz:Miecz;

    public var wrazliwy:Bool = true;
    public var countdown:Int = -1;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
        makeGraphic(WIDTH, HEIGHT, FlxColor.WHITE);

        acceleration.y = GRAVITY;
        maxVelocity.y = TERMINAL_VELOCITY;

        allow_to_jump = true;
        health = 5;
    }

    override function update(elapsed:Float) {

        gatherInputs();
        if(this.isTouching(FlxObject.DOWN))
            {
                allow_to_jump = true;
            }
        atak(atakInput);
        var direction:Int = getMoveDirectionCoefficient(leftInput, rightInput);
        velocity.x = X_SPEED * direction;
        zraniony();
        jump(jumpInput);
        super.update(elapsed);
    }

    private function gatherInputs():Void {
        leftInput = FlxG.keys.pressed.A;
        rightInput = FlxG.keys.pressed.D;
        atakInput = FlxG.keys.justPressed.W;
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
            allow_to_jump = false;
            }
        }
    }
    private function atak(atakInput:Bool):Void{
        if(atakInput == true && attack_deley == -1)
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
    public function trafiony()
        {
            if(wrazliwy)
                {
                    health--;
                    countdown = 120;
                    wrazliwy = false;
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
}