package;

import bronie.Miecz;
import teren.Wall;
import przeciwnicy.Walker;
import postacie.Hero;
import flixel.FlxState;
import flixel.FlxG;
import przeciwnicy.Potwor;

class PlayState extends FlxState
{
	public var bohater:Hero;
	public var sciana:Wall;
	public var potwor:Walker;
	public var bron:Miecz;
	
	override public function create()
	{
		super.create();
		bohater = new Hero(100, 100);
		add(bohater);
		sciana = new Wall(100, 200);
		add(sciana);
		potwor = new Walker(400, 168);
		add(potwor);

		FlxG.camera.target = bohater;
	}

	override public function update(elapsed:Float)
	{
		FlxG.collide(bohater, sciana);
		FlxG.collide(potwor, sciana);
		FlxG.overlap(bohater.miecz, potwor, MobWeaponOverlap);
		FlxG.overlap(potwor, bohater, HeroMobOverlap);
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
			bohater.trafiony();
			if(bohater.health == 0)
				{
					bohater.kill();
				}
		}
}
