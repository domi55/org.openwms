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
package org.openwms.web.flex.client.util {

    import org.granite.tide.spring.Identity;

    [Name]
    [Bindable]
    /**
     * A SecurityUtil. Utility class to do some security related checks. Uses GDS Identity.
     *
     * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
     * @version $Revision$
     * @since 0.1
     */
    public class SecurityUtil {

        [Inject]
        /**
         * Injected Tide identity object.
         */
        public var identity : Identity;

        /**
         * Constructor.
         */
        public function SecurityUtil() : void {
            super();
        }

        /**
         * Use GDS identiy to check the grant with name grantName for permission.
         */
        public function hasPermissions(grantName : String) : Boolean {
            return identity.ifAllGranted(grantName);
        }
    }
}

