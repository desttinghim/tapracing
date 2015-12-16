package net.dimnstudios.taprace;

import luxe.States;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.geom.Vec2;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;

import luxe.components.physics.nape.*;

import net.dimnstudios.taprace.components.Sensor;

class Singleplayer extends State
{
	// Sprites
	var character : Sprite;
	var goal : Sprite;
	
	var boxcollider : BoxCollider;
	var sensor : Sensor;
	
	var time : Float;
	var started : Bool;
	
	override function onenter<T>(_:T)
	{
		started = false;
		
		Luxe.renderer.clear_color.tween(0.2,{ r:0.06, g:0.075, b:0.098 });
		Luxe.physics.nape.space.gravity = new Vec2(0,0);
		
		//Character sprite creation
		character = new Sprite({
			name: "character",
			name_unique: true,
			color: new Color().rgb(0xf94b04),
			pos: new Vector(Main.midx, 0),
			size: new Vector(64, 64)
		});
		boxcollider = new BoxCollider({
			name: "nape",
			body_type: BodyType.DYNAMIC,
			material: Material.wood(),
			x: character.pos.x,
			y: character.pos.y,
			w: character.size.x,
			h: character.size.y
		});
		character.add(boxcollider);
		//Character sprite creation
		
		//Goal sprite creation
		goal = new Sprite({
			name: "goal",
			color: new Color().rgb(0xf0f0f0),
			size: new Vector( Main.midx*2, 64 ),
			pos: new Vector( Main.midx, Main.midy*2 )
 		});
	 	sensor = new Sensor({
	 		name: "sensor",
	 		event: "goal",
	 		triggers: [ character ]
	 	});
	 	goal.add(sensor);
	 	Luxe.events.listen("goal", win);
		//Goal sprite creation
	} //onenter

	override function onleave<T>(_:T)
	{
		goal.destroy();
		goal = null;
		
		character.destroy();
		character = null;
		boxcollider = null;
	}

	override function update( dt:Float )
	{
		// if(goal.point_inside_AABB(character.pos))
		// {
		// 	win();
		// }
	} //update

	override function onkeyup( event:KeyEvent )
	{
		if(event.keycode == Main.leftcharacterkey) characteraction(character);
		if(event.keycode == Main.rightcharacterkey) characteraction(character);
	} //onkeyup

	override function ontouchup( event:TouchEvent )
	{
		if(character.point_inside(event.pos))
		{
			characteraction(character);
		}
	} //ontouchup

	function characteraction( char:Sprite )
	{
		if(!started)
		{
			started = true;
			time = Sys.time();
		}
		var body = char.get("nape").body;
		body.applyImpulse(new Vec2( 0, 100 ), body.position);
	} //characteraction

	function win( e:Dynamic )
	{
		time = Sys.time() - time;
		trace('You win! Your time is $time');
		Main.state.unset("singleplayer");
		Main.state.set("menu");
	}
}