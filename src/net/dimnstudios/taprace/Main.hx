package net.dimnstudios.taprace;

import luxe.Input;
import luxe.States;

class Main extends luxe.Game 
{

	//Variables for remappable keys
	public static var leftcharacterkey	: Int;
	public static var leftitemkey		: Int;
	public static var rightcharacterkey	: Int;
	public static var rightitemkey		: Int;

	var state 	: States;

	override function ready()
	{
		leftcharacterkey 	= Key.key_z;
		leftitemkey 		= Key.key_x;
		rightcharacterkey 	= Key.comma;
		rightitemkey 		= Key.period;

		state = new States();

		state.add(new Level({name: "level" }));

		state.set("level");
	} //ready

	override function update( dt:Float )
	{

	} //update

} //Main
