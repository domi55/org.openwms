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
package org.openwms.web.flex.client.common.util {

    import mx.resources.ResourceManager;
    import org.openwms.web.flex.client.util.I18nUtil;

    [Name]
    [Bindable]
    /**
     * An I18nUtil is an extention of the core I18nUtil to provide properties definitions specific to the COMMON module.
     * It is a simple extension class to avoid multiple import declarations within the classes that are using I18nUtil.
     *
     * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
     * @version $Revision: 1422 $
     * @since 0.1
     */
    public class I18nUtil extends org.openwms.web.flex.client.util.I18nUtil {

        /**
         * Used as bundle resource name for all errors within the COMMON module.
         */
        public static const COMMON_ERROR : String = "commonError";
        /**
         * Used as bundle resource name for all texts within the COMMON module.
         */
        public static const COMMON_MAIN : String = "commonMain";
        /**
         * Used as bundle resource name for all entity translations within the COMMON module.
         */
        public static const COMMON_ENTITY : String = "commonEntity";

        /**
         * Constructor.
         */
        public function I18nUtil() : void {
            super();
        }

        /**
         * Translate a paramterized String into the language set by the user.
         * The first argument is expected to be the String, the rest arbitrary parameters.
         *
         * @param args An arbitrary list. At least the first parameter must be set as the
         * String to be translated
         */
        public static function trans(bundle : String, key : String, ... args) : String {
            return ResourceManager.getInstance().getString(bundle, key, args);
        }
    }
}

