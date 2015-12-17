package net.dimnstudios.taprace;

import luxe.States;
import luxe.Text;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.tween.Actuate;

class Menu extends State
{
	var text : Text;
	var lowscore : Text;
	
	override function onenter<T>(_:T)
	{
	    // TODO(louis): Replace all of this with a mint powered interface
	    // Eventually, this will be the Menu state mentioned in the structure
	    // part of the game design document (TapRacingGDD.md)
	    
		// TODO(louis): actually learn what this is doing
	 	Luxe.renderer.clear_color.tween(0.2,{ r:0.06, g:0.075, b:0.098 });
	 	Luxe.camera.pos = new Vector(0,0);
	 	
	 	// TODO(louis): Figure out why this text is not displaying
		text = new Text({
			text: "tap racing",
			align: center,
			align_vertical: center,
			point_size: 96,
			letter_spacing: 0,
// 			font: Main.font,
			pos: new Vector(Luxe.screen.mid.x,-171),
			color: new Color().rgb(0x7f7243),
			sdf: true,
			outline: 0.6,
		 	outline_color: new Color().rgb(0x1d150c)
		});
		
		lowscore = new Text({
		    text: '${Main.lowscore}',
		    align: center,
		    align_vertical: center,
		    point_size: 72,
		    letter_spacing: 0,
		    pos: new Vector(-200, Luxe.screen.mid.y),
            color: new Color().rgb(0x7f7f7f),
            sdf: true
		});
		
		
        Actuate.tween(text.pos, 2, { y:64 })
               .ease( luxe.tween.easing.Bounce.easeOut );
        Actuate.tween(lowscore.pos, 2, { x:Main.midx })
               .ease( luxe.tween.easing.Bounce.easeOut );
	}
	
	override function onleave<T>(_:T)
	{
	    // Cleaning up variables and sprites
		text.destroy();
		text = null;
		
		lowscore.destroy();
		lowscore = null;
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