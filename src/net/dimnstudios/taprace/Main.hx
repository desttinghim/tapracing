package net.dimnstudios.taprace;

import luxe.Game;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Screen;

import phoenix.geometry.QuadGeometry;

class Main extends luxe.Game 
{
	public var player1	: Sprite;
	public var player2	: Sprite;
	// Make this into a component
	public var acceleration1 : Vector;
	public var acceleration2 : Vector;
	public var velocity1	: Vector;
	public var velocity2	: Vector;
	// Allow this to be loaded in
	public var tapAccel : Float = 500;
	public var friction : Float = .8;
	//Eventually import all data from CastleDB: images, characters, items, levels
	//But not right now.

	override function config(config:luxe.AppConfig) {

        #if web
        config.window.fullscreen = true;
        #end

        return config;
    }

    override function onwindowsized( e:WindowEvent ) {
        Luxe.camera.viewport = new luxe.Rectangle( 0, 0, e.event.x, e.event.y);
    }

	override function ready()
	{
		// #if js
		// net.dimnstudios.taprace.Data.load(null);
		// #else
		// net.dimnstudios.taprace.Data.load(haxe.Resource.getString("assets/taprace.cdb"))
		// #end

		velocity1 = new Vector();
		velocity2 = new Vector();
		acceleration1 = new Vector();
		acceleration2 = new Vector();

		player1 = new Sprite({
			name: "player1",
			pos: new Vector(Luxe.screen.w/4,Luxe.screen.h),
			depth: -2,
			centered: true,
			color: new Color(0.4, 0.4, 0.4)
		});
		player2 = new Sprite({
			name: "player2",
			pos: new Vector(Luxe.screen.w-Luxe.screen.w/4,Luxe.screen.h),
			depth: -2,
			centered: true,
			color: new Color(0.4, 0.4, 0.4)
		});
	} //ready

	override function ontouchup( e:TouchEvent )
	{
		if(e.x < Luxe.screen.mid.x)
			acceleration1.y += tapAccel;
		if(e.x > Luxe.screen.mid.x)
			acceleration2.y += tapAccel;
	} 

	override function onmouseup( e:MouseEvent )
	{
		if(e.x < Luxe.screen.mid.x)
			acceleration1.y -= tapAccel;
		if(e.x > Luxe.screen.mid.x)
			acceleration2.y -= tapAccel;
	} //onmouseup

	override function update( dt:Float )
	{
		player1.pos.x += velocity1.x * dt;
		player2.pos.x += velocity2.x * dt;
		player1.pos.y += velocity1.y * dt;
		player2.pos.y += velocity2.y * dt;
		
		velocity1.x += (acceleration1.x - friction * velocity1.x) * dt;
		velocity2.x += (acceleration2.x - friction * velocity2.x) * dt;
		velocity1.y += (acceleration1.y - friction * velocity1.y) * dt;
		velocity2.y += (acceleration2.y - friction * velocity2.y) * dt;

		acceleration1.x *= 0.1;
		acceleration2.x *= 0.1;
		acceleration1.y *= 0.1;
		acceleration2.y *= 0.1;
	} //update

} //Main
