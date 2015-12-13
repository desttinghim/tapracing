package net.dimnstudios.taprace;

import luxe.States;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;
import luxe.Camera;
import luxe.Rectangle;
import luxe.Component;

import phoenix.Batcher;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.geom.Vec2;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionType;

import luxe.components.physics.nape.*;

import net.dimnstudios.taprace.components.Sensor;

enum WIN 
{
	left;
	right;
}

class Level extends State
{
	// Sprites
	var sprites : Array<Sprite>;

	// Camera
	var cameras : Array<Camera>;
	var batchers : Array<Batcher>;

	var components : Array<Component>;

	var goalType:CbType = new CbType();
	var charType:CbType = new CbType();

	override function onenter<T>(_:T)
	{
		cameras = new Array();
		batchers = new Array();

		for(i in 0...2) 
		{
			cameras.push(new Camera({ name: "camera_" + i }));
			batchers.push(Luxe.renderer.create_batcher({ name: "batcher_" + i, camera: cameras[i].view }));
		}

		cameras[0].viewport = new Rectangle(			0, 			0, 		Main.midx,	Luxe.screen.h);
		cameras[1].viewport = new Rectangle(	Main.midx, 			0, 		Main.midx,	Luxe.screen.h);

		Luxe.physics.nape.space.gravity = new Vec2(0,0);

		var goalType:CbType = new CbType();
		var charType:CbType = new CbType();

		//collision listener
		Luxe.physics.nape.space.listeners.add(new InteractionListener(
			CbEvent.BEGIN, InteractionType.SENSOR, 
			goalType, charType,
			goalToChar
			));

		//Sprites
		sprites = new Array();
		components = new Array();
		for(i in 0...2) 
		{
			sprites.push(new Sprite({
				name: "character",
				name_unique: true,
				color: new Color().rgb(0xf94b04 + i * 300),
				size: new Vector(64, 64)
				}));
			components.push(new BoxCollider({
				name: "nape",
				body_type: BodyType.DYNAMIC,
				material: Material.wood(),
				x: sprites[i].pos.x,
				y: sprites[i].pos.y,
				w: sprites[i].size.x,
				h: sprites[i].size.y
				}));
			sprites[i].add(components[i]);
			for(a in 0...2)
			{
				batchers[a].add(sprites[i].geometry);
			}
		}

		sprites[2] = new Sprite({
			name: "goal",
			color: new Color().rgb(0xf0f0f0),
			size: new Vector(Main.midx, 64)
			});
		batchers[0].add(sprites[2].geometry);
		batchers[1].add(sprites[2].geometry);
		components.push(new Sensor({
			name: "sensor",
			cbtype: goalType,
			shape: new Polygon(Polygon.box(Main.midx, 64))
			}));
		sprites[2].add(components[2]);

		//win listener (Is this even necessary?)
		Luxe.events.listen("win", function( e:WIN ){
			trace(e);
			});
	} //onenter

	var once : Bool = true;

	override function update( dt:Float )
	{
		if(once)
		{
			once = false;
			for(i in 0...2)
			{
				if(components[i].name == "nape")
				{ 
					var collider : BoxCollider = cast components[i];
					collider.body.cbTypes.add(charType);
				}
				if(components[i].name == "sensor")
				{
					var sensor = cast components[2];
					sensor.position.set_xy(Main.midx, Main.midy*2);
				}
				if(sprites[2].name == "goal")
				{
					var goal = sprites[2];
					goal.pos.set_xy(Main.midx, Main.midy*2);
				}
			}
		}
		cameras[0].center = sprites[0].pos;
		cameras[1].center = sprites[1].pos;
	}

	// override function onleave<T>(_:T)
	// {

	// } //onleave

	// override function update( dt:Float )
	// {

	// } //update

	override function onkeyup( event:KeyEvent )
	{
		if(event.keycode == Main.leftcharacterkey) characteraction(sprites[0]);
		if(event.keycode == Main.leftitemkey) leftitem();
		if(event.keycode == Main.rightcharacterkey) characteraction(sprites[1]);
		if(event.keycode == Main.rightitemkey) rightitem();
	} //onkeyup

	override function ontouchup( event:TouchEvent )
	{
		if(event.pos.x < Main.midx)
		{
			if(sprites[0].point_inside(event.pos))
			{
				characteraction(sprites[0]);
			}
		}	
		else
		{
			if(sprites[1].point_inside(event.pos))
			{
				characteraction(sprites[1]);
			}
		}
	} //ontouchup

	public function leftitem()
	{
		trace("left item");
	} //leftitem

	public function rightitem()
	{
		trace("right item");
	} //rightitem

	public function characteraction( char:Sprite )
	{
		var body = char.get("nape").body;
		body.applyImpulse(new Vec2( 0, 100 ), body.position);
	} //characteraction

	public function goalToChar( cb:InteractionCallback )
	{
		trace("Someone wins!");
		var id = cb.int2.id;
		var charleftid = sprites[0].get("nape").id;
		var charrightid = sprites[1].get("nape").id;
		if(charleftid == id)
		{
			Luxe.events.fire("win", WIN.left);
		}
		if(charrightid == id)
		{
			Luxe.events.fire("win", WIN.right);
		}
	}
}