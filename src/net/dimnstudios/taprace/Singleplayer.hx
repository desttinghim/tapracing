package net.dimnstudios.taprace;

import luxe.States;
import luxe.Text;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;
import luxe.tween.Actuate;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.geom.Vec2;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;

import luxe.components.physics.nape.*;

import net.dimnstudios.taprace.components.Sensor;

class Singleplayer extends State
{
	// Sprites
	var character : Sprite;
	var goal : Sprite;
	var node_goto : Sprite;
	var node1 : Sprite;
	var node2 : Sprite;
	
	var boxcollider : BoxCollider;
	var sensor : Sensor;
	var counter_text : Text;
	
	var counter : Float;
	var started : Bool;
	
	override function onenter<T>(_:T)
	{
		started = false;
		counter = 0;
		
		Luxe.renderer.clear_color.tween(0.2,{ r:0.06, g:0.075, b:0.098 });
		Luxe.physics.nape.space.gravity = new Vec2(0,0);
		Luxe.physics.nape.space.worldLinearDrag = 0.5;
		
		// Making character sprite. Most of the stuff I'm passing in is 
		// arbitrary, some of it is needed. Color and size are needed to make the
		// sprite visible, but the values of them are arbitrary
		//Character sprite creation
		character = new Sprite({
			name: "character",
			name_unique: true,
			color: new Color().rgb(0xf94b04),
			pos: new Vector(Main.midx, 0),
			size: new Vector(64, 64)
		});
		// Boxcollider is physics component from nape. All of the options need to
		// be passed in, though body_type and material are completely arbitrary.
		boxcollider = new BoxCollider({
			name: "nape",
			body_type: BodyType.DYNAMIC,
			material: Material.wood(),
			x: character.pos.x,
			y: character.pos.y,
			w: character.size.x,
			h: character.size.y
		});
		// Adding the physics component to our sprite so they move together and
		// are actually useful. I'm not sure what would happen if I had the component
		// sitting around by itself.
		character.add(boxcollider);
		//Character sprite creation
		
		// Making a goal sprite. 
		//Goal sprite creation
		goal = new Sprite({
			name: "goal",
			color: new Color().rgb(0xf0f0f0),
			size: new Vector( 64, 64 ),
			pos: new Vector( Main.midx * 2, 0 )
 		});
	 	sensor = new Sensor({
	 		name: "sensor",
	 		event: "goal",
	 		triggers: [ character ]
	 	});
	 	goal.add(sensor);
	 	Luxe.events.listen("goal", win);
		//Goal sprite creation
		
		//node creation
		node1 = new Sprite({
		    name: "node1",
		    color: new Color().rgb(0x456789),
		    size: new Vector(64,64),
		    pos: new Vector(Main.midx, Main.midy)
		});
		node1.add(new Sensor({
		    name: "sensor",
		    event: "node1",
		    triggers: [ character ]
		}));
		Luxe.events.listen("node1", function(_) {
		    node_goto = node2; // When player reaches node1, begin going to node2
		});
		
		node2 = new Sprite({
		    name: "node2",
		    color: new Color().rgb(0x456789),
		    size: new Vector(64,64),
		    pos: new Vector(Main.midx * 2, Main.midy)
		});
        node2.add(new Sensor({
           name: "sensor",
           event: "node2",
           triggers: [ character ]
        }));
        Luxe.events.listen("node2", function(_) {
            node_goto = goal; // Beginn going to goal after reaching node2
        });
        
        
        node_goto = node1; //Start path with node1
        //end node creation
        
        
         counter_text = new Text({text: '$counter', pos: new Vector(0,0)});
	} //onenter

	override function onleave<T>(_:T)
	{
		goal.destroy();
		goal = null;
		
		character.destroy();
		character = null;
		boxcollider = null;
		
		node1.destroy();
		node2.destroy();
		node1 = null;
		node2 = null;
		
		counter_text.destroy();
		counter_text = null;
	}
	
	override function update( dt:Float )
	{
	    counter += dt;
	    counter_text.text = '$counter';
	    counter_text.pos = character.pos;
	    
	    Luxe.camera.center = character.pos;
	}

	override function onkeyup( event:KeyEvent )
	{
		if(event.keycode == Main.leftcharacterkey) characteraction(character);
		if(event.keycode == Main.rightcharacterkey) characteraction(character);
	} //onkeyup

	override function ontouchup( event:TouchEvent )
	{
		if(character.point_inside(event.pos))
		{
			characteraction(character);
		}
	} //ontouchup

	function characteraction( char:Sprite )
	{
		if(!started) started = true;
		
		char.size = new Vector(70,70);
		Actuate.tween( char.size, 0.2, {x:64,y:64} );
		
		var body = char.get("nape").body;
		
		var xdist, ydist, normalized_vector;
		xdist = node_goto.pos.x - char.pos.x;
		ydist = node_goto.pos.y - char.pos.y;
		normalized_vector = new Vec2(xdist, ydist).normalise();
		
		body.applyImpulse(normalized_vector.mul(100), body.position);
	} //characteraction

	function win( e:Dynamic )
	{
		if(counter < Main.lowscore)
		{
		    Main.lowscore = counter;
		}
		trace('You win! Your time is $counter');
		Main.state.unset("singleplayer");
		Main.state.set("menu");
	}
}