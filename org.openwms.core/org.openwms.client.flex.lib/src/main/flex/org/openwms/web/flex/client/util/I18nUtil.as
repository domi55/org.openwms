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

    import mx.resources.ResourceManager;

    [Name]
    [Bindable]
    /**
     * An I18nUtil is an utility class for i18n translations.
     *
     * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
     * @version $Revision$
     * @since 0.1
     */
    public class I18nUtil {

        /**
         * Shortcut for ResourceBundle appError to refer to all application errors.
         */
        public static const APP_ERROR : String = "appError";

        /**
         * Shortcut for ResourceBundle appMain to all texts and messages in the main application.
         */
        public static const APP_MAIN : String = "appMain";

        /**
         * Shortcut for ResourceBundle appEntity to store all property names of entites classes in the main application.
         */
        public static const APP_ENTITY : String = "appEntity";

        /**
         * Shortcut for ResourceBundle corLibError to refer to all defined errors within the core library.
         */
        public static const COR_LIB_ERROR : String = "corLibError";

        /**
         * Shortcut for ResourceBundle corLibMain to all texts and messages in the core library.
         */
        public static const COR_LIB_MAIN : String = "corLibMain";

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
         * @param bundle The bundle to search in
         * @param key The key to search for
         * @param args An arbitrary list. At least the first parameter must be set as the
         * String to be translated
         */
        public static function trans(bundle : String, key : String, ... args) : String {
            return ResourceManager.getInstance().getString(bundle, key, args);
        }
    }
}