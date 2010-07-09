package com.yahoo.astra.richtext
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import com.yahoo.astra.richtext.utils.TextFormatUtil;
	
	public class HTMLDocument extends Document
	{
		public function HTMLDocument(text:String = "")
		{
			super();
			
			this.text = text;
		}
		
		private var _text:String = "";
		public function get text():String
		{
			return this._text;
		}
		
		public function set text(value:String):void
		{
			this._text = value;
			
			var oldIgnore:Boolean = XML.ignoreWhitespace;
			XML.ignoreWhitespace = false;
			var htmlDocument:XML = new XML(text);
			XML.ignoreWhitespace = oldIgnore;
			var format:TextFormat = new TextFormat("Arial", 12, 0x000000, false, false, false);
			this.populateContainerNode(this, htmlDocument.children(), format);
		}
		
		protected function populateContainerNode(node:ContainerNode, children:XMLList, format:TextFormat = null):void
		{
			var childCount:int = children.length();
			for(var i:int = 0; i < childCount; i++)
			{
				var child:XML = children[i];
				switch(child.nodeKind())
				{
					case "element":
						var parsedData:Object = this.parseElement(child, format);
						if(parsedData is Node)
						{
							node.addChild(parsedData as Node);
						}
						else if(parsedData is Array)
						{
							this.addChildrenToNode(node, parsedData as Array);
						}
						break;
					case "text":
						var text:String = child.toString();
						
						//ignore text that contains only whitespace.
						if(text.replace(/\s*/, "").length == 0) break;
						
						//convert all whitespace to single spaces
						text = text.replace(/\s+/, " ");
						var textNode:TextNode = new TextNode(text, TextFormatUtil.clone(format));
						node.addChild(textNode);
						break;
					default:
						trace("unhandled kind:", child.nodeKind());
				}
			}
		}
		
		protected function addChildrenToNode(node:ContainerNode, children:Array):void
		{
			var nodeCount:int = children.length;
			for(var i:int = 0; i < nodeCount; i++)
			{
				var childNode:Node = children[i] as Node;
				node.addChild(childNode);
			}
		}
		
		protected function flattenContainerNode(node:ContainerNode):Array
		{
			var children:Array = [];
			var childCount:int = node.numChildren;
			for(var i:int = 0; i < childCount; i++)
			{
				var child:Node = node.getChildAt(i);
				if(child is ContainerNode)
				{
					children = children.concat(this.flattenContainerNode(child as ContainerNode));
				}
				else children.push(child);
			}
			return children;
		}
		
		protected function parseElement(element:XML, format:TextFormat = null):Object
		{
			format = this.parseTextStyles(element, format);
			var node:Node;
			switch(element.name().localName)
			{
				case "head":
					this.title = element.title.toString();
					break;
				case "body":
				case "div":
				case "ul":
				case "ol":
				case "li":
				case "p":
				case "h1":
				case "h2":
				case "h3":
				case "h4":
				case "h5":
				case "h6":
					node = this.parseGenericContainer(element, format);
					break;
				case "img":
					node = this.parseImage(element);
					break;
				case "span":
					break;
				case "a":
					break;
				case "cite":
				case "strong":
				case "em":
				case "b":
				case "i":
				case "u":
				case "font":
					return this.parseFormattingElement(element, format);
					break;
				default:
					trace("unknown element type:", element.name().localName);
			}
			return node;
		}
		
		protected function parseGenericContainer(element:XML, format:TextFormat):ContainerNode
		{
			var container:ContainerNode = new ContainerNode();
			this.populateContainerNode(container, element.children(), format);
			return container;
		}
		
		protected function parseImage(element:XML):MediaNode
		{
			var source:String = element.@src.toString();
			var image:Loader = new Loader();
			image.load(new URLRequest(source));
			var mediaNode:MediaNode = new MediaNode(image);
			return mediaNode;
		}
		
		protected function parseFormattingElement(element:XML, format:TextFormat):Array
		{
			var updatedFormat:TextFormat = TextFormatUtil.clone(format);
			switch(element.name().localName)
			{
				case "strong":
				case "b":
					updatedFormat.bold = true;
					break;
				case "em":
				case "i":
					updatedFormat.italic = true;
					break;
				case "u":
					updatedFormat.underline = true;
					break;
				case "font":
					updatedFormat = this.parseFontElement(element, format);
					break;
			}
			var node:ContainerNode = new ContainerNode();
			this.populateContainerNode(node, element.children(), updatedFormat);
			return this.flattenContainerNode(node);
		}
		
		protected function parseFontElement(element:XML, format:TextFormat):TextFormat
		{
			var updatedFormat:TextFormat = TextFormatUtil.clone(format);
			
			var attributes:XMLList = element.attributes();
			var attributeCount:int = attributes.length();
			for(var i:int = 0; i < attributeCount; i++)
			{
				var attribute:XML = attributes[i];
				switch(attribute.name().localName)
				{
					case "face":
						var fonts:Array = element.@face.toString().split(",");
						updatedFormat.font = fonts[0];
						break;
					case "size":
						updatedFormat.size = element.@size;
						break;
					case "color":
						updatedFormat.color = element.@color;
						break;
					default:
						trace("unknown attribute on font element:", attribute.name().localName);
				}
			}
			return updatedFormat;
		}
		
		protected function parseTextStyles(element:XML, format:TextFormat):TextFormat
		{
			var updatedFormat:TextFormat = TextFormatUtil.clone(format);
			if(element.attribute("style").length() > 0)
			{
				var styles:Array = element.@style.toString().split(";");
				var styleCount:int = styles.length;
				for(var i:int = 0; i < styleCount; i++)
				{
					var style:Array = styles[i].split(":");
					var styleName:String = style[0];
					var styleValue:String = style[1];
					switch(styleName)
					{
						case "font-family":
							var fonts:Array = styleValue.split(",");
							updatedFormat.font = fonts[0];
							break;
						case "font-size":
							updatedFormat.size = styleValue;
							break;
						case "font-weight":
							switch(styleValue)
							{
								case "bold":
									updatedFormat.bold = true;
									break;
								case "normal":
									updatedFormat.bold = false;
									break;
							}
							break;
						case "text-decoration":
							switch(styleValue)
							{
								case "underline":
									updatedFormat.underline = true;
									break;
								case "normal":
									updatedFormat.underline = false;
									break;
							}
							break;
						case "font-style":
							switch(styleValue)
							{
								case "italic":
									updatedFormat.italic = true;
									break;
								case "normal":
									updatedFormat.italic = false;
									break;
							}
							break;
						case "color":
							updatedFormat.color = styleValue;
							break;
						default:
							trace("unknown style:", styleName);
					}
				}
			}
			return updatedFormat;
		}
		
	}
}