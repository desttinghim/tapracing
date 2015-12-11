package net.dimnstudios.taprace;

import luxe.Vector;
import luxe.Input;
import luxe.Sprite;

import phoenix.geometry.QuadGeometry;

class Main extends luxe.Game 
{
	//Variables for remappable keys
	var leftcharacterkey	: Int;
	var leftitemkey			: Int;
	var rightcharacterkey	: Int;
	var rightitemkey		: Int;

	//Player sprites
	var leftcharactersprite		: Sprite;
	var rightcharactersprite	: Sprite;

	override function ready()
	{
		leftcharacterkey = Key.key_z;
		leftitemkey = Key.key_x;
		leftcharacterkey = Key.less;
		leftitemkey = Key.greater;
	} //ready

	override function update( dt:Float )
	{

	} //update

	override function onkeyup( event:KeyEvent )
	{
		if(event.keycode == leftcharacterkey) leftcharacter();
		if(event.keycode == leftitemkey) leftitem();
		if(event.keycode == rightcharacterkey) rightcharacter();
		if(event.keycode == rightitemkey) rightitem();
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

	} //leftcharacter

	public function leftitem()
	{

	} //leftitem

	public function rightcharacter()
	{

	} //rightcharacter

	public function rightitem()
	{

	} //rightitem

} //Main
