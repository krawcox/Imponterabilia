package;

import bronie.Tarcza;
import bronie.Fireball;
import flixel.FlxObject;
import bronie.Miecz;
import teren.Wall;
import przeciwnicy.Walker;
import postacie.Hero;
import flixel.FlxState;
import flixel.FlxG;
import przeciwnicy.Potwor;
import przeciwnicy.Mag;

class PlayState extends FlxState
{
	public static var PLAYER_START_POS_X(default, never):Int = 100;
    public static var PLAYER_START_POS_Y(default, never):Int = 100;


	public var bohater:Hero;
	public var sciana:Wall;
	public var potwor:Walker;
	public var bron:Miecz;
	public var mag:Mag;

	
	override public function create()
	{
		super.create();
		bohater = new Hero(PLAYER_START_POS_X, PLAYER_START_POS_Y);
		add(bohater);
		sciana = new Wall(100, 200);
		add(sciana);
		potwor = new Walker(400, 168);
		add(potwor);
		mag = new Mag(400, 10);
		add(mag);
		FlxG.camera.target = bohater;
	}

	override public function update(elapsed:Float)
	{
		FlxG.collide(bohater, sciana);
		FlxG.collide(potwor, sciana);
		FlxG.overlap(bohater.miecz, potwor, MobWeaponOverlap);
		FlxG.overlap(bohater.miecz, mag, MobWeaponOverlap);
		FlxG.overlap(potwor, bohater, HeroMobOverlap);
		FlxG.overlap(mag, bohater, HeroMobOverlap);
		FlxG.overlap(potwor.miecz, bohater, HeroMobOverlap);
		FlxG.overlap(mag.fireballs, bohater, FireballHeroOberlap);
		FlxG.overlap(mag.fireballs, sciana, WallFireballOverlap);
		FlxG.overlap(bohater.tarcza, mag.fireballs, TarczaFireballOverlap);
		FlxG.overlap(mag.fireballs, mag, FireballMobOverlap);
		FlxG.overlap(mag.fireballs, potwor, FireballMobOverlap);
		super.update(elapsed);
	}

	private function MobWeaponOverlap(bron:Miecz, mob:Potwor)
		{
			mob.hit();
			if(mob.health == 0)
				{
					mob.kill();
				}
		}
	private function HeroMobOverlap(mob:Potwor, bohater:Hero)
		{
			var strona:Int;
			if(bohater.x <= mob.x)
				{
					strona = FlxObject.LEFT;
				}
			else
				{
					strona = FlxObject.RIGHT;
				}
			bohater.trafiony(strona);
			if(bohater.health == 0)
				{
					bohater.kill();
				}
		}
	private function FireballHeroOberlap(fireball:Fireball, bohater:Hero)
		{
			var strona:Int;
			strona = fireball.facing;
			bohater.trafiony(strona);
			fireball.kill();
			if(bohater.health == 0)
				{
					bohater.kill();
				}
		}
	private function WallFireballOverlap(fireball:Fireball, wall:Wall)
		{
			fireball.kill();
		}
	private function TarczaFireballOverlap(tarcza:Tarcza, fireball:Fireball)
		{
			fireball.reflect();
		}
	private function FireballMobOverlap(fireball:Fireball, mob:Potwor)
		{
			mob.hit();
			fireball.kill();
			if(mob.health == 0)
				{
					mob.kill();
				}
		}
}
