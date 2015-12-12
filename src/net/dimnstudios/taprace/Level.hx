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

import luxe.components.physics.nape.*;

class Level extends State
{
	//Sprites
	var leftcharactersprite		: Sprite;
	var rightcharactersprite	: Sprite;

	//Camera
	var batcher_left	: Batcher;
	var batcher_right	: Batcher;
	var camera_left		: Camera;
	var camera_right	: Camera;
	var level_sprite	: Sprite;

	override function onenter<T>(_:T)
	{
		//create unique cameras
		camera_left = new Camera({ name: "camera_left" });
		camera_right = new Camera({ name: "camera_right" });

		//create unique batchers
		batcher_left = Luxe.renderer.create_batcher({ name: "batcher_left", camera: camera_left.view });
		batcher_right = Luxe.renderer.create_batcher({ name: "batcher_right", camera: camera_right.view });

		//create unique viewports
		camera_left.viewport = new Rectangle(			0, 		0, 		Main.midx,	Luxe.screen.h);
		camera_right.viewport = new Rectangle(	Main.midx, 		0, 		Main.midx,	Luxe.screen.h);

		// level_sprite = new Sprite({
		// 	name: "level_sprite",
		// 	color: new Color().rgb(0x0f0f0f),
		// 	pos: new Vector(0,0),
		// 	size: Luxe.screen.size,
		// 	centered: false,
		// 	batcher: batcher_left
		// 	}); //level_sprite

		// batcher_right.add(	level_sprite.geometry );

		camera_right.pos.x = Main.midx/2;



		//Creating Sprites
		leftcharactersprite = new Sprite({
			name: "left",
			pos: new Vector(Luxe.screen.w/4, Luxe.screen.mid.y),
			color: new Color().rgb(0xf94b04),
			size: new Vector(64, 64),
			batcher: batcher_left
			});
		batcher_right.add(	leftcharactersprite.geometry );

		rightcharactersprite = new Sprite({
			name: "right",
			pos: new Vector(Main.midx, Luxe.screen.mid.y),
			color: new Color().rgb(0x4bf904),
			size: new Vector(64, 64),
			batcher: batcher_left
			});
		batcher_right.add(	rightcharactersprite.geometry );


		//Creating nape physics bodies
		var leftcharactercol = new BoxCollider({
			name: "nape",
			body_type: BodyType.DYNAMIC,
			material: Material.wood(),
			x: leftcharactersprite.pos.x-leftcharactersprite.size.x,
			y: leftcharactersprite.pos.y-leftcharactersprite.size.y,
			w: leftcharactersprite.size.x,
			h: leftcharactersprite.size.y
			});

		var rightcharactercol = new BoxCollider({
			name: "nape",
			body_type: BodyType.DYNAMIC,
			material: Material.wood(),
			x: rightcharactersprite.pos.x-rightcharactersprite.size.x,
			y: rightcharactersprite.pos.y-rightcharactersprite.size.y,
			w: rightcharactersprite.size.x,
			h: rightcharactersprite.size.y
			});

		leftcharactersprite.add( leftcharactercol );
		rightcharactersprite.add( rightcharactercol );

		Luxe.physics.nape.space.gravity = new Vec2(0,0);
	} //onenter

	override function onleave<T>(_:T)
	{

	} //onleave

	override function update( dt:Float )
	{

	} //update

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
			if(leftcharactersprite.point_inside(event.pos))
			{
				leftcharacter();
			}
		}	
		else
		{
			if(rightcharactersprite.point_inside(event.pos))
			{
				rightcharacter();
			}
		}
	} //ontouchup

	public function leftcharacter()
	{
		trace("left character");
		character(leftcharactersprite);
	} //leftcharacter

	public function leftitem()
	{
		trace("left item");
	} //leftitem

	public function rightcharacter()
	{
		trace("right character");
		character(rightcharactersprite);
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
}