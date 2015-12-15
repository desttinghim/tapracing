package net.dimnstudios.taprace;

import luxe.Input;
import luxe.States;
import luxe.Text;

class Main extends luxe.Game 
{
	//Variables for remappable keys
	public static var leftcharacterkey	: Int;
	public static var leftitemkey		: Int;
	public static var rightcharacterkey	: Int;
	public static var rightitemkey		: Int;

	public static var midx;
	public static var midy;

	public static var state : States;
	
	public static var win : Bool = false;
	public static var font : phoenix.BitmapFont;
	
	override function config(config:luxe.AppConfig)
	{
		config.preload.fonts.push({
			id:"assets/font/proclamate.fnt"
		});
		
		return config;
	}

	override function ready()
	{
		font = Luxe.resources.font("assets/font/proclamate.fnt");
		
		leftcharacterkey 	= Key.key_z;
		leftitemkey 		= Key.key_x;
		rightcharacterkey 	= Key.comma;
		rightitemkey 		= Key.period;

		midx = Luxe.screen.mid.x;
		midy = Luxe.screen.mid.y;

		state = new States();
		
		state.add(new Level({name: "level" }));
		state.add(new Menu({name: "menu" }));

		state.set("menu");
		
	} //ready

	override function update( dt:Float )
	{
		
	} //update

} //Main
