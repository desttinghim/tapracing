package net.dimnstudios.taprace;

import luxe.States;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;

class Level extends State
{
	//Player sprites
	var leftcharactersprite		: Sprite;
	var rightcharactersprite	: Sprite;

	//Cameras

	override function onenter<T>(_:T)
	{
		leftcharactersprite = new Sprite({
			name: "left",
			pos: new Vector(Luxe.screen.w/4, Luxe.screen.mid.y),
			color: new Color().rgb(0xf94b04),
			size: new Vector(128, 128)
			});
		rightcharactersprite = new Sprite({
			name: "right",
			pos: new Vector(Luxe.screen.w - Luxe.screen.w/4, Luxe.screen.mid.y),
			color: new Color().rgb(0x4bf904),
			size: new Vector(128, 128)
			});
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