package net.dimnstudios.taprace.components;

import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.components.physics.nape.NapeBody;
import nape.shape.Shape;

import nape.callbacks.CbType;

typedef SensorOptions = {

    > NapeBodyOptions,
    
    @:optional var cbtype : CbType;

    @:optional var shape : Shape;

} //BoxColliderOptions

class Sensor extends NapeBody
{
	var options : SensorOptions;
	var shape : Shape;

	public function new( _options:SensorOptions )
	{
		options = _options;
		super(options);
	}

	override function onadded() : Void 
	{

        super.onadded();
        body.cbTypes.add(options.cbtype);
        body.space = Luxe.physics.nape.space;
        shape = options.shape;

        shape.sensorEnabled = true;
        shape.body = body;

    } //onadded
}