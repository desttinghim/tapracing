package net.dimnstudios.taprace;

import luxe.States;
import luxe.Text;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

class Menu extends State
{
	var text : Text;
	var sprite : Sprite;
	
	override function onenter<T>(_:T)
	{
	    // TODO(louis): Replace all of this with a mint powered interface
	    // Eventually, this will be the Menu state mentioned in the structure
	    // part of the game design document (TapRacingGDD.md)
	    
		// TODO(louis): actually learn what this is doing
	 	Luxe.renderer.clear_color.tween(0.2,{ r:0.06, g:0.075, b:0.098 });
	 	
	 	// TODO(louis): Figure out why this text is not displaying
		text = new Text({
			text: "Tap Racing: Menu",
			align: center,
			align_vertical: center,
			point_size: 96,
			letter_spacing: 0,
			font: Main.font,
			pos: new Vector(Luxe.screen.mid.x, -171),
			color: new Color().rgb(0x7f7243),
			outline: 0.6,
		 	outline_color: new Color().rgb(0x1d150c)
		});
		
		// Test sprite, because the text didn't work
		sprite = new Sprite({
			color: new Color().rgb(0xf0f0f0),
			size: new Vector(64, 64)
		});
	}
	
	override function onleave<T>(_:T)
	{
	    // Cleaning up variables and sprites
		text.destroy();
		text = null;
		
		sprite.destroy();
		sprite = null;
	}
	
	override function update( dt:Float )
	{
	    // When the 'leftcharacterkey' is released, go to the singleplayer mode
		if(Luxe.input.keyreleased(Main.leftcharacterkey))
		{
			Main.state.unset("menu");
			Main.state.set("singleplayer");
		}
	}
}