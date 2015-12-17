package net.dimnstudios.taprace;

import luxe.Input;
import luxe.States;
import luxe.Text;
import luxe.Parcel;
import luxe.Color;
import luxe.ParcelProgress;

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
	public static var lowscore : Float = 10;
	public static var font : phoenix.BitmapFont;

	override function ready()
	{
	    var parcel = new Parcel({
	        fonts: [{id:'assets/font/proclamate.fnt'}]
	    });
	    
	    new ParcelProgress({
	        parcel: parcel,
	        background: new Color(1,1,1,0.85),
	        oncomplete: assets_loaded
	    });
	    
	    parcel.load();
		
	} //ready
	
	function assets_loaded(_)
	{
        // Making a reference for the font asset
        font = Luxe.resources.font("assets/font/proclamate.fnt");
        
        // Setting default keyboard mappings
        leftcharacterkey     = Key.key_z;
        leftitemkey         = Key.key_x;
        rightcharacterkey     = Key.comma;
        rightitemkey         = Key.period;
        
        // Setting convenience variables for getting half the width of the screen
        midx = Luxe.screen.mid.x;
        midy = Luxe.screen.mid.y;
        
        // Creates a new state thingy. This holds all the different states
        // that will be switched between.
        state = new States();
        
        // Here is a state for multiplayer
        state.add(new Multiplayer({name: "multiplayer" }));
        // Another state for singleplayer
        state.add(new Singleplayer({name: "singleplayer" }));
        // And a state for the menu
        state.add(new Menu({name: "menu" }));

        // Finally, we set the state to 'menu' (where else would we start?)
        // This sends us to the onenter method of Menu.hx 
        state.set("menu");
	}
}
} //Main
