/*
 * openwms.org, the Open Warehouse Management System.
 * Copyright (C) 2014 Heiko Scherrer
 *
 * This file is part of openwms.org.
 *
 * openwms.org is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as 
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * openwms.org is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software. If not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */
package org.openwms.web.flex.client.common.event {

    import flash.events.Event;

    /**
     * A LocationEvent.
     *
     * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
     * @version $Revision$
     * @since 0.1
     */
    public class LocationEvent extends Event {

        /**
         * Event to load all Locations from the backend service.
         */
        public static const LOAD_ALL_LOCATIONS : String = "LOAD_ALL_LOCATIONS";
        /**
         * Event to save the Location stored in data.
         */
        public static const SAVE_LOCATION : String = "SAVE_LOCATION";
        /**
         * Event to remove one or more Messages from a Location.
         *
         * data is expected to hold an object with {id:id, messages:ArrayCollection of Messages}
         */
        public static const REMOVE_MESSAGES : String = "LOC.REMOVE_MESSAGES";

        /**
         * Store arbitrary data.
         */
        public var data : *;

        /**
         * Constructor.
         */
        public function LocationEvent(type : String, bubbles : Boolean=true, cancelable : Boolean=false) {
            super(type, bubbles, cancelable);
        }

        /**
         * Just a copy of the event itself including the data field.
         *
         * @return a copy of this
         */
        public override function clone() : Event {
            var e : LocationEvent = new LocationEvent(type);
            e.data = data;
            return e;
        }

        /**
         * Simple override.
         *
         * @return the type of event
         */
        public override function toString() : String {
            return formatToString("LocationEvent", "type");
        }
    }
}