package {
import com.adamatomic.flixel.*;
import com.adobe.serialization.json.*;

import flash.errors.*;
import flash.events.*;
import flash.net.Socket;

public class NetSock extends Socket {
    
    public var listeners:Object = new Object();

    public function NetSock(host:String = null, port:uint = 0) {
        super(host, port);
        configureListeners();
    }

    private function configureListeners():void {
        addEventListener(Event.CLOSE, closeHandler);
        addEventListener(Event.CONNECT, connectHandler);
        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
    }
    
    public function on(command:String, func:Function):void {
    	listeners[command] = func;
    } 

    private function writeln(str:String):void {
        str += "\n";
        try {
            writeUTFBytes(str);
        }
        catch(e:IOError) {
            FlxG.log(e.toString());
            CombatTanks.tracker.trackEvent("Errors", "Network", e.toString());
        }
    }

    public function send(command:String, payload:Object = null):void {
    	if (payload) 
    		writeln(command + "::" + JSON.encode(payload));
    	else 
    		writeln(command + "::");
        flush();
    }

    private function closeHandler(event:Event):void {
        FlxG.log("closeHandler: " + event);
    }

    private function connectHandler(event:Event):void {
        send("FINDGAME");
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        FlxG.log("ioErrorHandler: " + event);
        CombatTanks.tracker.trackEvent("Errors", "Network", event.toString());
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        FlxG.log("securityErrorHandler: " + event);
        CombatTanks.tracker.trackEvent("Errors", "Network", event.toString());
    }

    private function socketDataHandler(event:ProgressEvent):void {
    	for each (var line:String in readUTFBytes(bytesAvailable).split("\n")) {
        	var input:Array = line.split("::");
        	var command:String = input[0];
        	var payload:Object;
        	FlxG.log(line);
        	if (input.length > 1 && input[1].length > 1)
        		payload = JSON.decode(input[1]);
        	else
        		payload = {};
        	if (listeners.hasOwnProperty(command))
        		listeners[command](payload);
     	}
    }
}
}