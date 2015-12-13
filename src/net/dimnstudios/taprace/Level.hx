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
	//Sprites
	var leftcharactersprite		: Sprite;
	var rightcharactersprite	: Sprite;
	var goalsprite	: Sprite;

	//Camera
	var batcher_left	: Batcher;
	var batcher_right	: Batcher;
	var camera_left		: Camera;
	var camera_right	: Camera;

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

		goalsprite = new Sprite({
			name: "goal",
			color: new Color().rgb(0xf0f0f0),
			size: new Vector(Main.midx*2, 64),
			batcher: batcher_left
			});
		batcher_right.add(	goalsprite.geometry );


		//Creating nape physics bodies
		var goalCollisionType:CbType = new CbType();
		var characterCollisionType:CbType = new CbType();

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
		var goalcol = new Sensor({
			cbtype: goalCollisionType,
			shape: new Polygon(Polygon.box(Main.midx, 64))
			});
		goalsprite.add(goalcol);
		goalcol.body.position.setxy(0,Main.midy*2);


		// var goalcol = new Body();
		// goalcol.space = Luxe.physics.nape.space;
		// goalcol.position.setxy(0, Main.midy*2);

		// var goalshape:Shape = new Polygon(Polygon.box(Main.midx, 64));
		// goalshape.sensorEnabled = true;
		// goalshape.body = goalcol;

		leftcharactersprite.add( leftcharactercol );
		rightcharactersprite.add( rightcharactercol );

		Luxe.physics.nape.space.gravity = new Vec2(0,0);

		// goalcol.cbTypes.add(goalCollisionType);
		leftcharactercol.body.cbTypes.add(characterCollisionType);
		rightcharactercol.body.cbTypes.add(characterCollisionType);

		//collision listener
		Luxe.physics.nape.space.listeners.add(new InteractionListener(
			CbEvent.BEGIN, InteractionType.SENSOR, 
			goalCollisionType, characterCollisionType,
			goalToChar
			));

		//win listener (Is this even necessary?)
		Luxe.events.listen("win", function( e:WIN ){
			trace(e);
			});
	} //onenter

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

	public function goalToChar( cb:InteractionCallback )
	{
		trace("Someone wins!");
		var id = cb.int2.id;
		var charleftid = leftcharactersprite.get("nape").id;
		var charrightid = rightcharactersprite.get("nape").id;
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