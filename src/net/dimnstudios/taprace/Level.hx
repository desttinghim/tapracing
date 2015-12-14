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

import luxe.components.physics.nape.*;

class Level extends State
{
	// Sprites
	var sprites : Array<Sprite>;
	var characters : Array<Sprite>;

	// Camera
	var cameras : Array<Camera>;
	var batchers : Array<Batcher>;

	var components : Array<Component>;

	override function onenter<T>(_:T)
	{
		cameras = new Array();
		batchers = new Array();

		for(i in 0...2) 
		{
			cameras.push(new Camera({ name: "camera_" + i }));
			batchers.push(Luxe.renderer.create_batcher({ name: "batcher_" + i, camera: cameras[i].view }));
		}

		Luxe.camera.active = false;

		cameras[0].viewport = new Rectangle(			0, 			0, 		Main.midx,	Luxe.screen.h);
		cameras[1].viewport = new Rectangle(	Main.midx, 			0, 		Main.midx,	Luxe.screen.h);

		Luxe.physics.nape.space.gravity = new Vec2(0,0);

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
		characters = sprites.copy();

		sprites[2] = new Sprite({
			name: "goal",
			color: new Color().rgb(0xf0f0f0),
			size: new Vector(Main.midx, 64),
			pos: new Vector(0,Main.midy*2)
			});
		batchers[0].add(sprites[2].geometry);
		batchers[1].add(sprites[2].geometry);
	} //onenter

	var once : Bool = true;

	override function update( dt:Float )
	{
		for(character in characters)
		{
			if(sprites[2].point_inside_AABB(character.pos))
			{
				win( character );
			}
		}
		cameras[0].center = sprites[0].pos;
		cameras[1].center = sprites[1].pos;
	}

	override function onkeyup( event:KeyEvent )
	{
		if(event.keycode == Main.leftcharacterkey) characteraction(sprites[0]);
		if(event.keycode == Main.rightcharacterkey) characteraction(sprites[1]);
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

	function characteraction( char:Sprite )
	{
		var body = char.get("nape").body;
		body.applyImpulse(new Vec2( 0, 100 ), body.position);
	} //characteraction

	function win( character:Sprite )
	{
		trace(character.name + " wins!");
	}
}