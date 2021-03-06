package  
{
	import benkuper.nativeExtensions.Spout;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import org.tuio.connectors.UDPConnector;
	import org.tuio.osc.IOSCListener;
	import org.tuio.osc.OSCManager;
	import org.tuio.osc.OSCMessage;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Spout2Demo extends Sprite implements IOSCListener
	{
		//spout stuff
		private var spout:Spout;
		private var sendName:String = "AIR Sender";
		
		//drawing sprite
		private var s:Sprite;
		private var bd:BitmapData;
		
		//ribbon stuff
		private var ribbonManager:RibbonManager;
		private var ribbonAmount:int = 5;
		private var ribbonParticleAmount:int = 20;
		private var randomness:Number = .2
		private var oscM:OSCManager;
		
		
		public function Spout2Demo() 
		{
			super();
			
			setupRibbon();
			
			bd = new BitmapData(stage.stageWidth, stage.stageHeight,false,0);
			
			spout = new Spout();
			
			var createResult:Boolean = spout.extContext.call("createSender", sendName, bd.width, bd.height) as Boolean;
			trace("createSender result :", createResult);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			//var bm:Bitmap = new Bitmap(bd);
			//addChild(bm);
			//bm.x = 100;
			
			
			oscM = new OSCManager(new UDPConnector("127.0.0.1", 6000));
			oscM.addMsgListener(this);
			
		}
		
		/* INTERFACE org.tuio.osc.IOSCListener */
		
		public function acceptOSCMessage(msg:OSCMessage):void 
		{
			switch(msg.address)
			{
				case "/myo/orientation":
					//trace("update", msg.arguments[1], msg.arguments[2]);
					ribbonManager.update(stage.stageWidth /2 + msg.arguments[1]*stage.stageWidth/2, stage.stageHeight/2 - msg.arguments[2] * stage.stageHeight/2);
					
					break;
			}
		}
		
		private function enterFrame(e:Event):void 
		{
			ribbonManager.update(mouseX, mouseY);
			
			bd.fillRect(new Rectangle(0, 0, bd.width, bd.height), 0);
			bd.draw(s);
			
			
			spout.extContext.call("sendTexture",sendName, bd);
		}
		
		
		private function setupRibbon():void 
		{
			s = new Sprite();
			addChild(s);
			s.filters = [new GlowFilter(0xff0000,1,50,50,2,2)];
  			ribbonManager = new RibbonManager(s, ribbonAmount, ribbonParticleAmount, randomness, "rothko_01.jpg");    // field, rothko_01-02, absImp_01-03 picasso_01
  			ribbonManager.setRadiusMax(8);			// default = 8
  			ribbonManager.setRadiusDivide(10);		// default = 10
  			ribbonManager.setGravity(.03);			// default = .03
  			ribbonManager.setFriction(1.1);			// default = 1.1
  			ribbonManager.setMaxDistance(150);		// default = 40
  			ribbonManager.setDrag(2);				// default = 2
			ribbonManager.setDragFlare(.008);		// default = .008
			
						

		}
		
	}

}