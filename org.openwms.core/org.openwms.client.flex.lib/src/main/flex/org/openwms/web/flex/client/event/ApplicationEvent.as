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
package org.openwms.web.flex.client.event {

    import flash.events.Event;

    /**
     * An ApplicationEvent used for some management purpose.
     *
     * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
     * @version $Revision$
     * @since 0.1
     */
    public class ApplicationEvent extends Event {

        /**
         * Name of the Event to load all modules.
         */
        public static const LOAD_ALL_MODULES : String = "LOAD_ALL_MODULES";

        /**
         * Name of the Event to unload all modules.
         */
        public static const UNLOAD_ALL_MODULES : String = "UNLOAD_ALL_MODULES";

        /**
         * Name of the Event to signal that the module configuration has changed.
         */
        public static const MODULE_CONFIG_CHANGED : String = "MODULE_CONFIG_CHANGED";

        /**
         * Name of the Event to signal that the module configuration has finished.
         */
        public static const MODULES_CONFIGURED : String = "MODULES_CONFIGURED";

        /**
         * Name of the Event to save a Module.
         */
        public static const SAVE_MODULE : String = "SAVE_MODULE";

        /**
         * Name of the Event to delete a Module.
         */
        public static const DELETE_MODULE : String = "DELETE_MODULE";

        /**
         * Name of the Event to load a single Module.
         */
        public static const LOAD_MODULE : String = "LOAD_MODULE";

        /**
         * Name of the Event to unload a single Module.
         */
        public static const UNLOAD_MODULE : String = "UNLOAD_MODULE";

        /**
         * Name of the Event to notify components before a Module is unloaded.
         */
        public static const BEFORE_MODULE_UNLOAD : String = "APP.BEFORE_MODULE_UNLOAD";

        /**
         * Name of the Event to notify the ModuleManager that the Module can be unloaded.
         */
        public static const READY_TO_UNLOAD : String = "APP.READY_TO_UNLOAD";

        /**
         * Name of the Event to signal that a Module was successfully loaded.
         */
        public static const MODULE_LOADED : String = "MODULE_LOADED";

        /**
         * Name of the Event to signal that a Module was successfully unloaded.
         */
        public static const MODULE_UNLOADED : String = "MODULE_UNLOADED";

        /**
         * Name of the Event to save the startupOrders of a list of Modules.
         */
        public static const SAVE_STARTUP_ORDERS : String = "SAVE_STARTUP_ORDERS";

        /**
         * Name of the Event to request a login call to the backend service.
         */
        public static const APP_REQUEST_LOGIN : String = "APP.REQUEST_LOGIN";

        /**
         * Name of the Event to signal that an User successfully logged in.
         */
        public static const APP_LOGIN_OK : String = "APP.LOGIN_OK";

        /**
         * Name of the Event to signal that a login request wasn't successful.
         */
        public static const APP_LOGIN_NOK : String = "APP.LOGIN_NOK";

        /**
         * Name of the Event to signal that passed credentials are valid.
         */
        public static const APP_CREDENTIALS_VALID : String = "APP.CREDENTIALS_VALID";

        /**
         * Name of the Event to signal that passed credentials aren't valid.
         */
        public static const APP_CREDENTIALS_INVALID : String = "APP.CREDENTIALS_INVALID";

        /**
         * Name of the Event to force an User logout.
         */
        public static const LOGOUT : String = "APP_LOGOUT";

        /**
         * Name of the Event to force a screen lock.
         */
        public static const LOCK : String = "APP_LOCK";

        /**
         * Name of the Event to unlock the application.
         */
        public static const APP_UNLOCK : String = "APP.UNLOCK";

        /**
         * Name of the Event to clear all data in model classes.
         */
        public static const APP_CLEAR_MODEL : String = "APP.CLEAR_MODEL";

        /**
         * Name of the Event to merge grants with the backend.
         */
        public static const MERGE_GRANTS : String = "APP.MERGE_GRANTS";

        /**
         * Name of the Event when security objects were updated.
         */
        public static const SECURITY_OBJECTS_REFRESHED : String = "APP.SECURITY_OBJECTS_REFRESHED";

        /**
         * Store arbitrary data.
         */
        public var data : *;

        /**
         * Constructor.
         */
        public function ApplicationEvent(type : String) {
            super(type, true, false);
        }

        /**
         * Just a copy of the event itself including the data field.
         *
         * @return a copy of this
         */
        public override function clone() : Event {
            var e : ApplicationEvent = new ApplicationEvent(type);
            e.data = data;
            return e;
        }

        /**
         * Simple override.
         *
         * @return the type of event
         */
        public override function toString() : String {
            return formatToString("ApplicationEvent", "type");
        }
    }
}

