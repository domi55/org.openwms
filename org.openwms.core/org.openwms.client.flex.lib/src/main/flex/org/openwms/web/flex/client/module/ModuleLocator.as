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
package org.openwms.web.flex.client.module {

    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.controls.Alert;
    import mx.events.ModuleEvent;
    import mx.logging.ILogger;
    import mx.logging.Log;
    import mx.modules.IModuleInfo;
    import mx.modules.ModuleManager;
    
    import org.granite.reflect.Type;
    import org.granite.tide.events.TideFaultEvent;
    import org.granite.tide.events.TideResultEvent;
    import org.granite.tide.spring.Context;
    import org.granite.tide.spring.Identity;
    import org.openwms.core.domain.Module;
    import org.openwms.web.flex.client.IApplicationModule;
    import org.openwms.web.flex.client.event.ApplicationEvent;
    import org.openwms.web.flex.client.model.ModelLocator;
    import org.openwms.web.flex.client.util.I18nUtil;

    [Name]
    [ManagedEvent(name = "MODULE_CONFIG_CHANGED")]
    [ManagedEvent(name = "MODULES_CONFIGURED")]
    [ManagedEvent(name = "MODULE_LOADED")]
    [ManagedEvent(name = "MODULE_UNLOADED")]
    [ManagedEvent(name = "APP.BEFORE_MODULE_UNLOAD")]
    [ResourceBundle("corLibError")]
    [Bindable]
    /**
     * A ModuleLocator is the main implementation that cares about handling
     * with Flex Modules with the CORE Flex Application.
     * It is a Tide component and can be injected by name=moduleLocator.
     * It fires the following Tide Events:
     * MODULE_CONFIG_CHANGED, MODULES_CONFIGURED, MODULE_LOADED, MODULE_UNLOADED, APP.BEFORE_MODULE_UNLOAD.
     *
     * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
     * @version $Revision$
     * @since 0.1
     */
    public class ModuleLocator extends EventDispatcher {

        [Inject]
        /**
         * Needs a Model to work on.
         */
        public var modelLocator : ModelLocator;

        [Inject]
        /**
         * Needs a TideContext.
         */
        public var tideContext : Context;

        [Inject]
        /**
         * Injected Tide identity object.
         */
        public var identity : Identity;

        private var toRemove : Module;

        private var _applicationDomain : ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);

        private static var logger : ILogger = Log.getLogger("org.openwms.web.flex.client.module.ModuleLocator");

        /**
         * Simple constructor used by the Tide framework.
         */
        public function ModuleLocator() {
            Type.registerDomain(_applicationDomain);
        }

        [Observer("LOAD_ALL_MODULES")]
        /**
         * Usually this method is called when the application is initialized,
         * to load all modules and module configuration from the service.
         * After this startup configuration is read, the application can then
         * LOAD the swf modules.
         *
         * @param event Unused
         */
        public function loadModulesFromService(event : ApplicationEvent) : void {
            trace("Loading all module definitions from the database");
            tideContext.moduleService.findAll(onModulesLoad, onFault);
        }

        [Observer("UNLOAD_ALL_MODULES")]
        /**
         * Is called when the UNLOAD_ALL_MODULES is fired to unload all Modules.
         * It iterates through the list of loadedModules and triggers unloading each of them.
         *
         * @param event Unused
         */
        public function unloadAllModules(event : ApplicationEvent) : void {
            for (var url : String in modelLocator.loadedModules) {
                triggerUnload(modelLocator.loadedModules[url].data.module as Module);
            }
        }

        [Observer("SAVE_MODULE")]
        /**
         * Tries to save the module data via a service call.
         * Is called when the SAVE_MODULE event is fired.
         *
         * @param event An ApplicationEvent that holds the Module to be saved in its data field
         */
        public function saveModule(event : ApplicationEvent) : void {
            tideContext.moduleService.save(event.data as Module, onModuleSaved, onFault);
        }

        [Observer("DELETE_MODULE")]
        /**
         * Tries to remove the module data via a service call.
         * Is called when the DELETE_MODULE event is fired.
         *
         * @param event An ApplicationEvent that holds the Module to be removed in its data field
         */
        public function deleteModule(event : ApplicationEvent) : void {
            toRemove = event.data as Module;
            tideContext.moduleService.remove(event.data as Module, onModuleRemoved, onFault);
        }

        [Observer("SAVE_STARTUP_ORDERS")]
        /**
         * A collection of modules is passed to the service to save the startupOrder properties.
         * The startupOrders must be calculated and ordered before. Is called when the
         * SAVE_STARTUP_ORDERS event is fired.
         *
         * @param event An ApplicationEvent holds a list of Modules that shall be updated
         */
        public function saveStartupOrders(event : ApplicationEvent) : void {
            tideContext.moduleService.saveStartupOrder(event.data as ArrayCollection, onStartupOrdersSaved, onFault);
        }

        [Observer("LOAD_MODULE")]
        /**
         * Checks whether the module a registered Module and calls loadModule to load it.
         *
         * @param event An ApplicationEvent holds the Module to be loaded within the data property
         */
        public function onLoadModule(event : ApplicationEvent) : void {
            var module : Module = event.data as Module;
            if (module == null) {
                trace("Module instance is NULL, skip loading");
                return;
            }
            if (!isRegistered(module)) {
                trace("Module was not found in list of all modules");
                return;
            }
            loadModule(module);
        }

        [Observer("UNLOAD_MODULE")]
        /**
         * Checks whether the module a registered Module and calls unloadModule to unload it.
         *
         * @param event An ApplicationEvent holds the Module to be unloaded within the data property
         */
        public function onUnloadModule(event : ApplicationEvent) : void {
            var module : Module = event.data as Module;
            if (module == null) {
                trace("Module instance is NULL, skip unloading");
                return;
            }
            if (!isRegistered(module)) {
                trace("Module was not found in list of registered modules");
                return;
            }

            triggerUnload(module);
        }

        [Observer("APP.READY_TO_UNLOAD")]
        /**
         * Checks whether the module a registered Module and calls unloadModule to unload it.
         *
         * @param event An ApplicationEvent holds the Module to be unloaded within the data property
         */
        public function readyToUnload(event : ApplicationEvent) : void {
            var module : Module = event.data.module as Module;
            var mInf : IModuleInfo = event.data.mInf as IModuleInfo;
            var appModule : IApplicationModule = event.data.appModule as IApplicationModule;
            unloadModule(module, appModule, mInf);
        }

        /**
         * Returns an ArrayCollection of MenuItems of all loaded modules.
         *
         * @param stdItems A list of standard items that are included in the result list per default
         */
        public function getActiveMenuItems(stdItems : XMLListCollection=null) : XMLListCollection {
            var all : XMLListCollection = new XMLListCollection();
            if (stdItems != null) {
                for each (var stdNode : XML in stdItems) {
                    all.addItem(stdNode);
                }
            }
            for each (var module : Module in modelLocator.allModules) {
                if (modelLocator.loadedModules[module.url] != null) {
                    // Get an handle to IApplicationModule here to retrieve the list of items
                    // not like it is here to get the info from the db
                    var mInf : IModuleInfo = modelLocator.loadedModules[module.url] as IModuleInfo;
                    var appModule : Object = mInf.factory.create();
                    if (appModule is IApplicationModule) {
                        var tree : XMLListCollection = appModule.getMainMenuItems();
                        // TODO: In Flex 3.5 replace with addAll()
                        //all.addAll(tree);
                        for each (var node : XML in tree) {
                            all.addItem(node);
                        }
                    }
                }
            }
            return all;
        }

        /**
         * Check whether the module is in the list of persistend modules.
         *
         * @param module The Module to be checked
         * @return <code>true</code> when the module is known, otherwise <code>false</code>
         */
        public function isRegistered(module : Module) : Boolean {
            if (module == null) {
                return false;
            }
            for each (var m : Module in modelLocator.allModules) {
                if (m.moduleName == module.moduleName) {
                    return true;
                }
            }
            return false;
        }

        /**
         * Checks whether a module as loaded before.
         *
         * @param moduleName The name of the Module to check
         * @return <code>true</code> if the module was loaded, otherwise <code>false</code>.
         */
        public function isLoaded(moduleName : String) : Boolean {
            if (moduleName == null) {
                return false;
            }
            for each (var url : String in modelLocator.loadedModules) {
                if ((modelLocator.loadedModules[url].data as Module).moduleName == moduleName) {
                    return true;
                }
            }
            return false;
        }

        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //
        // privates
        //
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        /**
         * Callback function when module configuration is retrieved from the service.
         * The configuration is stored in allModules and the model is set to initialized.
         */
        private function onModulesLoad(event : TideResultEvent) : void {
            modelLocator.allModules = event.result as ArrayCollection;
            modelLocator.isInitialized = true;
            startAllModules();
        }

        /**
         * Callback when startupOrder was saved for a list of modules.
         */
        private function onStartupOrdersSaved(event : TideResultEvent) : void {
            // We do not need to update the list of modules here, keep quite
        }

        /**
         * This function checks all known modules if they are configured to be loaded
         * on startup and tries to start each Module if it hasn't been loaded so far.
         */
        private function startAllModules() : void {
            var noModulesLoaded : Boolean = true;
            for each (var module : Module in modelLocator.allModules) {
                if (module.loadOnStartup) {
                    noModulesLoaded = false;
                    // TODO: Remove the following expression
                    if (modelLocator.loadedModules[module.url] != null) {
                        module.loaded = true;
                        continue;
                    }
                    trace("Trying to load module : " + module.url);
                    loadModule(module);
                } else {
                    logger.debug("Module not set to be loaded on startup : " + module.moduleName);
                }
            }
            if (noModulesLoaded) {
                dispatchEvent(new ApplicationEvent(ApplicationEvent.MODULES_CONFIGURED));
            }
        }

        private function loadModule(module : Module) : void {
            var mInf : IModuleInfo = ModuleManager.getModule(module.url);
            if (mInf != null) {
                if (mInf.loaded) {
                    module.loaded = true;
                    trace("Module was already loaded : " + module.moduleName);
                    return;
                } else {
                    mInf.addEventListener(ModuleEvent.READY, onModuleLoaded, false, 0, true);
                    mInf.addEventListener(ModuleEvent.ERROR, onModuleLoaderError);
                    mInf.data = {module: module, mInf: mInf, appModule: null};
                    trace("Putting in loadedModules:" + module.url);
                    modelLocator.loadedModules[module.url] = mInf;
                    mInf.load(_applicationDomain);
                    return;
                }
            }
            trace("No module to load with url: " + module.url);
            // TODO: Show ALert box to user
        }

        //
        private function triggerUnload(module : Module) : void {
            var mInf : IModuleInfo = modelLocator.loadedModules[module.url];
            trace("Before unloading of module: " + module.url);
            delete modelLocator.loadedModules[module.url];
            fireBeforeUnloadEvent(mInf.data.appModule, mInf, mInf.data.module);
            return;
        }

        private function unloadModule(module : Module, appModule : IApplicationModule, mInf : IModuleInfo) : void {
            if (!modelLocator.unloadedModules.hasOwnProperty(module.url)) {
                mInf.addEventListener(ModuleEvent.UNLOAD, onModuleUnloaded);
                mInf.addEventListener(ModuleEvent.ERROR, onModuleLoaderError);
                mInf.data = {module: module, mInf: mInf, appModule: appModule};
                modelLocator.unloadedModules[module.url] = mInf;
                try {
                    appModule.destroyModule();
                } catch (e : Error) {
                    trace("Error on destroying Module: " + e.message);
                }
                //Spring.getInstance().initApplication();
                mInf.unload();
                //mInf.release();
                return;
            } else {
                logger.debug("Module was not loaded before, nothing to unload");
            }
        }

        /**
         * When module data was saved successfully it is updated in the list of modules
         * and set as actual selected module.
         */
        private function onModuleSaved(event : TideResultEvent) : void {
            addModule(event.result as Module);
            modelLocator.selectedModule = event.result as Module;
        }

        /**
         * When module data was removed successfully it is updated in the list of modules
         * and unset as selected module.
         */
        private function onModuleRemoved(event : TideResultEvent) : void {
            removeFromModules(toRemove);
            toRemove = null;
        }

        /**
         * Fire an event to notify others that configuration data of a module has changed.
         * The event data (e.data) contains the changed module.
         */
        private function fireChangedEvent(module : IApplicationModule) : void {
            var e : ApplicationEvent = new ApplicationEvent(ApplicationEvent.MODULE_CONFIG_CHANGED);
            e.data = module;
            dispatchEvent(e);
        }

        private function fireBeforeUnloadEvent(appModule : IApplicationModule, mInf : IModuleInfo, module : Module) : void {
            var e : ApplicationEvent = new ApplicationEvent(ApplicationEvent.BEFORE_MODULE_UNLOAD);
            e.data = {appModule: appModule, mInf: mInf, module: module};
            dispatchEvent(e);
        }

        /**
         * This method is called when an application module was successfully loaded.
         * Loading a module can be triggered by the Module Management screen or at application
         * startup if the module is configured to behave so.
         */
        private function onModuleLoaded(e : ModuleEvent) : void {
            trace("Successfully loaded module: " + e.module.url);
            (e.module.data.module as Module).loaded = true;

            delete modelLocator.unloadedModules[e.module.url];
            modelLocator.loadedModules[e.module.url] = e.module;

            var appModule : Object = e.module.factory.create();
            if (appModule is IApplicationModule) {
                e.module.data.appModule = appModule as IApplicationModule;
                //Spring.getInstance().addModule(Object(appModule).constructor as Class, _applicationDomain);
                appModule.start(_applicationDomain);
            } else {
                trace("Module that was loaded is not an IApplicationModule");
            }
            e.module.removeEventListener(ModuleEvent.READY, onModuleLoaded);
            e.module.removeEventListener(ModuleEvent.ERROR, onModuleLoaderError);
            if (appModule is IApplicationModule) {
                fireLoadedEvent(e.module.data);
            }
        }

        /**
         * This method is called when an application module was successfully unloaded. Unloading
         * a module is usually triggered by the Module Management screen or on logout. As a result an event is
         * fired to inform the main application about the unload process. For instance the main application
         * could rebuild the menu bar and organize the main ViewStack.
         */
        private function onModuleUnloaded(e : ModuleEvent) : void {
            trace("Successfully hard-unloaded Module with URL : " + e.module.url);
            (e.module.data.module as Module).loaded = false;

            delete modelLocator.loadedModules[e.module.url];
            modelLocator.unloadedModules[e.module.url] == e.module;

            var appModule : Object = e.module.data.appModule;
            e.module.removeEventListener(ModuleEvent.UNLOAD, onModuleUnloaded);
            e.module.removeEventListener(ModuleEvent.ERROR, onModuleLoaderError);
            if (appModule is IApplicationModule) {
                fireUnloadedEvent(appModule as IApplicationModule);
            } else {
                trace("Module that was unloaded is not an IApplicationModule");
            }
            e.module.release();
        }

        /**
         * Fire an event to notify others that a module was successfully unloaded.
         * The event data (e.data) contains the module that was loaded.
         */
        private function fireLoadedEvent(data : Object) : void {
            var e : ApplicationEvent = new ApplicationEvent(ApplicationEvent.MODULE_LOADED);
            e.data = data;
            dispatchEvent(e);
        }

        /**
         * Fire an event to notify others that a module was successfully unloaded.
         * The event data (e.data) contains the module that was unloaded.
         */
        private function fireUnloadedEvent(module : IApplicationModule) : void {
            var e : ApplicationEvent = new ApplicationEvent(ApplicationEvent.MODULE_UNLOADED);
            e.data = module;
            dispatchEvent(e);
        }

        /**
         * This method is called when an error occurred while loading or unloading a module.
         */
        private function onModuleLoaderError(e : ModuleEvent) : void {
            if (e.module != null) {
                trace("Loading / unloading a module [" + e.module.url + "] failed with error : " + e.errorText);
                if (e.module.data != null && e.module.data is Module) {
                    trace("1");
                    var module : Module = (e.module.data as Module);
                    trace("2");
                    module.loaded = false;
                    trace("3");
                    var mInf : IModuleInfo = modelLocator.loadedModules[module.url] as IModuleInfo;
                    trace("4");
                    if (mInf != null) {
                        trace("5");
                        // TODO: Also remove other listeners here
                        mInf.removeEventListener(ModuleEvent.ERROR, onModuleLoaderError);
                        trace("6");
                        modelLocator.unloadedModules[module.url] = mInf;
                    }
                    trace("7");
                    delete modelLocator.loadedModules[module.url];
                }
                Alert.show(I18nUtil.trans(I18nUtil.COR_LIB_ERROR, "error_module_loading_details", e.module.url, e.errorText));
            } else {
                trace("Loading / unloading a module failed with error: "+e.errorText);
                Alert.show(I18nUtil.trans(I18nUtil.COR_LIB_ERROR, "error_module_loading"));
            }
        }

        /**
         * Add a module to the list of all modules.
         */
        private function addModule(module : Module) : void {
            if (module == null) {
                return;
            }
            var found : Boolean = false;
            for each (var m : Module in modelLocator.allModules) {
                if (m.moduleName == module.moduleName) {
                    found = true;
                    m = module;
                }
            }
            if (!found) {
                modelLocator.allModules.addItem(module);
            }
            if (modelLocator.loadedModules[module.url] != null) {
                modelLocator.loadedModules[module.url] = ModuleManager.getModule(module.url);
            }
            if (modelLocator.unloadedModules[module.url] != null) {
                modelLocator.unloadedModules[module.url] = ModuleManager.getModule(module.url);
            }
        }

        /**
         * Removes a module from the list of all modules and unloads it in the case it was loaded before.
         */
        private function removeFromModules(module : Module, unload : Boolean=false) : Boolean {
            if (module == null) {
                return false;
            }
            var modules : Array = modelLocator.allModules.toArray();
            for (var i : int = 0; i < modules.length; i++) {
                if (modules[i].moduleName == module.moduleName) {
                    modelLocator.allModules.removeItemAt(i);
                    if (unload) {
                        var mInfo : IModuleInfo = ModuleManager.getModule(module.url);
                        mInfo.addEventListener(ModuleEvent.READY, onModuleLoaded);
                        mInfo.addEventListener(ModuleEvent.ERROR, onModuleLoaderError);
                        if (mInfo != null && mInfo.loaded) {
                            mInfo.data = module;
                            mInfo.unload();
                        }
                    }
                    return true;
                }
            }
            return false;
        }

        private function onFault(event : TideFaultEvent) : void {
            trace("Error executing operation on ModuleManagement service:" + event.fault);
            Alert.show(I18nUtil.trans(I18nUtil.COR_LIB_ERROR, "error_module_general"));
        }

    }
}

