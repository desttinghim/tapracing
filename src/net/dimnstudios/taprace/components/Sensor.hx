package net.dimnstudios.taprace.components;

import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Sprite;
import luxe.Entity;

typedef SensorOptions = {

	> ComponentOptions,
	
	var event : String;
	
	var triggers : Array<Sprite>;
} //SensorOptions


class Sensor extends Component
{
	var sprite : Sprite;
	var event : String;
	var triggers : Array<Sprite>;
	var options : SensorOptions;
	
	function new( _options:SensorOptions )
	{
		options = _options;
		event = options.event;
		super(options);
	}
	
	override function onadded()
	{
		trace("Sensor added");
		triggers = options.triggers;
		sprite = cast entity;
	}
	
	override function update( dt:Float )
	{
		for(entity in triggers)
		{
			if(sprite.point_inside(entity.pos))
			{
				trace(event);
				Luxe.events.fire(event);
			}
		}
	}
}