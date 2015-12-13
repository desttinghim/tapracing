package net.dimnstudios.taprace.components;

import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.phys.nape.components.NapeBody;
import nape.callbacks.CbType;

class Sensor extends NapeBody
{
	public static const SENSOR:CbType = new CbType();

	public function new(_name:String, params:Object)
	{
		super({ name:_name });
	}
}