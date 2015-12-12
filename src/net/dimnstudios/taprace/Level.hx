package net.dimnstudios.taprace;

import luxe.States;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;
import luxe.Camera;
import luxe.Rectangle;

import phoenix.Batcher;

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
		if(leftcharactersprite.point_inside(event.pos))
		{
			leftcharacter();
		}
		if(rightcharactersprite.point_inside(event.pos))
		{
			rightcharacter();
		}
	} //ontouchup

	public function leftcharacter()
	{
		trace("left character");
	} //leftcharacter

	public function leftitem()
	{
		trace("left item");
	} //leftitem

	public function rightcharacter()
	{
		trace("right character");
	} //rightcharacter

	public function rightitem()
	{
		trace("right item");
	} //rightitem
}