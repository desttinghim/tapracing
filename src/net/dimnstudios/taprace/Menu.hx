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
		trace("Menu.onenter");
	 	Luxe.renderer.clear_color.tween(0.2,{ r:0.06, g:0.075, b:0.098 });
	 	
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
		
		sprite = new Sprite({
			color: new Color().rgb(0xf0f0f0),
			size: new Vector(64, 64)
		});
	}
	
	override function onleave<T>(_:T)
	{
		trace("Menu.onleave");
		text.destroy();
		text = null;
		
		sprite.destroy();
		sprite = null;
	}
	
	override function update( dt:Float )
	{
		if(Luxe.input.keyreleased(Main.leftcharacterkey))
		{
			Main.state.unset("menu");
			Main.state.set("singleplayer");
		}
	}
}