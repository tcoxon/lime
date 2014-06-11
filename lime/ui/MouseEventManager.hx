package lime.ui;


import lime.app.EventManager;
import lime.system.System;


@:allow(lime.ui.Window)
class MouseEventManager extends EventManager<IMouseEventListener> {
	
	
	private static var instance:MouseEventManager;
	
	private var mouseEvent:MouseEvent;
	
	
	public function new () {
		
		super ();
		
		instance = this;
		mouseEvent = new MouseEvent ();
		
		#if (cpp || neko)
		
		lime_mouse_event_manager_register (handleEvent, mouseEvent);
		
		#end
		
	}
	
	
	public static function addEventListener (listener:IMouseEventListener, priority:Int = 0):Void {
		
		if (instance != null) {
			
			instance._addEventListener (listener, priority);
			
		}
		
	}
	
	
	#if js
	private function handleDOMEvent (event:js.html.MouseEvent):Void {
		
		/*
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			__mouseX = (event.clientX - rect.left) * (stageWidth / rect.width);
			__mouseY = (event.clientY - rect.top) * (stageHeight / rect.height);
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			//__mouseX = (event.clientX - rect.left) * (__div.style.width / rect.width);
			__mouseX = (event.clientX - rect.left);
			//__mouseY = (event.clientY - rect.top) * (__div.style.height / rect.height);
			__mouseY = (event.clientY - rect.top);
			
		}
		*/
		
		mouseEvent.x = event.clientX;
		mouseEvent.y = event.clientY;
		
		mouseEvent.type = switch (event.type) {
			
			case "mousedown": MOUSE_DOWN;
			case "mouseup": MOUSE_UP;
			case "mousemove": MOUSE_MOVE;
			//case "click": MouseEvent.CLICK;
			//case "dblclick": MouseEvent.DOUBLE_CLICK;
			case "mousewheel": MOUSE_WHEEL;
			default: null;
			
		}
		
		handleEvent (mouseEvent);
		
	}
	#end
	
	
	private function handleEvent (event:MouseEvent):Void {
		
		var event = event.clone ();
		
		switch (event.type) {
			
			case MOUSE_DOWN:
				
				for (listener in listeners) {
					
					listener.onMouseDown (event);
					
				}
			
			case MOUSE_UP:
				
				for (listener in listeners) {
					
					listener.onMouseUp (event);
					
				}
			
			case MOUSE_MOVE:
				
				for (listener in listeners) {
					
					listener.onMouseMove (event);
					
				}
			
			default:
			
		}
		
	}
	
	
	private static function registerWindow (window:Window):Void {
		
		if (instance != null) {
			
			#if js
			window.element.addEventListener ("mousedown", instance.handleDOMEvent, true);
			window.element.addEventListener ("mousemove", instance.handleDOMEvent, true);
			window.element.addEventListener ("mouseup", instance.handleDOMEvent, true);
			//window.element.addEventListener ("mousewheel", handleDOMEvent, true);
			#end
			
		}
		
	}
	
	
	public static function removeEventListener (listener:IMouseEventListener):Void {
		
		if (instance != null) {
			
			instance._removeEventListener (listener);
			
		}
		
	}
	
	
	#if (cpp || neko)
	private static var lime_mouse_event_manager_register = System.load ("lime", "lime_mouse_event_manager_register", 2);
	#end
	
	
}