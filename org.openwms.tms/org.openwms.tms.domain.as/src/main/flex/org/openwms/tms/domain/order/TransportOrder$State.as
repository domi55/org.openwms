/**
 * Generated by Gas3 v2.0.0 (Granite Data Services).
 *
 * WARNING: DO NOT CHANGE THIS FILE. IT MAY BE OVERWRITTEN EACH TIME YOU USE
 * THE GENERATOR.
 */

package org.openwms.tms.domain.order {

    import org.granite.util.Enum;

    [Bindable]
    [RemoteClass(alias="org.openwms.tms.domain.order.TransportOrder$State")]
    public class TransportOrder$State extends Enum {

        public static const CREATED:TransportOrder$State = new TransportOrder$State("CREATED", _);
        public static const INITIALIZED:TransportOrder$State = new TransportOrder$State("INITIALIZED", _);
        public static const STARTED:TransportOrder$State = new TransportOrder$State("STARTED", _);
        public static const INTERRUPTED:TransportOrder$State = new TransportOrder$State("INTERRUPTED", _);
        public static const ONFAILURE:TransportOrder$State = new TransportOrder$State("ONFAILURE", _);
        public static const CANCELED:TransportOrder$State = new TransportOrder$State("CANCELED", _);
        public static const FINISHED:TransportOrder$State = new TransportOrder$State("FINISHED", _);

        function TransportOrder$State(value:String = null, restrictor:* = null) {
            super((value || CREATED.name), restrictor);
        }

        override protected function getConstants():Array {
            return constants;
        }

        public static function get constants():Array {
            return [CREATED, INITIALIZED, STARTED, INTERRUPTED, ONFAILURE, CANCELED, FINISHED];
        }

        public static function valueOf(name:String):TransportOrder$State {
            return TransportOrder$State(CREATED.constantOf(name));
        }
    }
}