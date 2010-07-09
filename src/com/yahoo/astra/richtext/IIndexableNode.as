package com.yahoo.astra.richtext
{
	public interface IIndexableNode
	{
		function get length():int;
		function split(index:int):Array;
		//function join(node:IIndexableNode):IIndexableNode;
		//function getItemAt(index:int):Object;
	}
}