package net.dimnstudios.taprace;

import luxe.States;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;
import luxe.Camera;
import luxe.Rectangle;

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

	var goalType:CbType = new CbType();
	var charType:CbType = new CbType();

	override function onenter<T>(_:T)
	{
		cameras = new Array();
		batchers = new Array();

		for(i in 0...2) 
		{
			cameras.push(new Camera({ name: "camera" }));
			batchers.push(Luxe.renderer.create_batcher({ name: "batcher", camera: cameras[i].view }));
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
		for(i in 0...2) 
		{
			sprites.push(new Sprite({
				name: "character",
				color: new Color().rgb(0xf94b04 + i * 300),
				size: new Vector(64, 64)
				}));
			sprites[i].add(new BoxCollider({
				name: "nape",
				body_type: BodyType.DYNAMIC,
				material: Material.wood(),
				x: sprites[i].pos.x,
				y: sprites[i].pos.y,
				w: sprites[i].size.x,
				h: sprites[i].size.y
				}));
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
		sprites[2].add(new Sensor({
			name: "sensor",
			cbtype: goalType,
			shape: new Polygon(Polygon.box(Main.midx, 64))
			}));

		//win listener (Is this even necessary?)
		Luxe.events.listen("win", function( e:WIN ){
			trace(e);
			});
	} //onenter

	var once : Bool = true;
	var twice : Bool = true;

	override function update( dt:Float )
	{
		// if(once || twice)
		// {
		// 	once = false;
		// 	if(once)
		// 		return;
		// 	twice = false;
		// 	for(i in 0...2)
		// 	{
		// 		var collider = sprites[i].get("nape");
		// 		collider.body.cbTypes.add(charType);
		// 	}
		// }
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
		if(event.keycode == Main.leftcharacterkey) leftcharacter();
		if(event.keycode == Main.leftitemkey) leftitem();
		if(event.keycode == Main.rightcharacterkey) rightcharacter();
		if(event.keycode == Main.rightitemkey) rightitem();
	} //onkeyup

	override function ontouchup( event:TouchEvent )
	{
		if(event.pos.x < Main.midx)
		{
			if(sprites[0].point_inside(event.pos))
			{
				leftcharacter();
			}
		}	
		else
		{
			if(sprites[1].point_inside(event.pos))
			{
				rightcharacter();
			}
		}
	} //ontouchup

	public function leftcharacter()
	{
		trace("left character");
		character(sprites[0]);
	} //leftcharacter

	public function leftitem()
	{
		trace("left item");
	} //leftitem

	public function rightcharacter()
	{
		trace("right character");
		character(sprites[1]);
	} //rightcharacter

	public function rightitem()
	{
		trace("right item");
	} //rightitem

	public function character( char:Sprite )
	{
		var body = char.get("nape").body;
		body.applyImpulse(new Vec2( 0, 100 ), body.position);
	} //character

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