/**
 * Generated by Gas3 v2.0.0 (Granite Data Services).
 *
 * WARNING: DO NOT CHANGE THIS FILE. IT MAY BE OVERWRITTEN EACH TIME YOU USE
 * THE GENERATOR. INSTEAD, EDIT THE INHERITED CLASS (UnitError.as).
 */

package org.openwms.common.domain.system {

    import flash.events.EventDispatcher;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;
    import flash.utils.getQualifiedClassName;
    import mx.core.IUID;
    import mx.utils.UIDUtil;
    import org.granite.collections.IPersistentCollection;
    import org.granite.meta;
    import org.granite.tide.IEntity;
    import org.granite.tide.IEntityManager;
    import org.granite.tide.IPropertyHolder;

    use namespace meta;

    [Managed]
    public class UnitErrorBase implements IExternalizable, IUID {

        protected var _em:IEntityManager = null;

        private var __initialized:Boolean = true;
        private var __detachedState:String = null;

        private var _errorNo:String;
        private var _errorText:String;
        private var _id:Number;

        meta function isInitialized(name:String = null):Boolean {
            if (!name)
                return __initialized;

            var property:* = this[name];
            return (
                (!(property is UnitError) || (property as UnitError).meta::isInitialized()) &&
                (!(property is IPersistentCollection) || (property as IPersistentCollection).isInitialized())
            );
        }

        [Transient]
        public function meta_getEntityManager():IEntityManager {
            return _em;
        }
        public function meta_setEntityManager(em:IEntityManager):void {
            _em = em;
        }

        public function set errorNo(value:String):void {
            _errorNo = value;
        }
        public function get errorNo():String {
            return _errorNo;
        }

        public function set errorText(value:String):void {
            _errorText = value;
        }
        public function get errorText():String {
            return _errorText;
        }

        public function get id():Number {
            return _id;
        }

        public function set uid(value:String):void {
            // noop...
        }
        public function get uid():String {
        	if (isNaN(_id))
        		return UIDUtil.createUID();
        	return getQualifiedClassName(this) + "#[" + String(_id) + "]";
        	
        }

        public function meta_merge(em:IEntityManager, obj:*):void {
            var src:UnitErrorBase = UnitErrorBase(obj);
            __initialized = src.__initialized;
            __detachedState = src.__detachedState;
            if (meta::isInitialized()) {
               em.meta_mergeExternal(src._errorNo, _errorNo, null, this, 'errorNo', function setter(o:*):void{_errorNo = o as String});
               em.meta_mergeExternal(src._errorText, _errorText, null, this, 'errorText', function setter(o:*):void{_errorText = o as String});
               em.meta_mergeExternal(src._id, _id, null, this, 'id', function setter(o:*):void{_id = o as Number});
            }
            else {
               em.meta_mergeExternal(src._id, _id, null, this, 'id', function setter(o:*):void{_id = o as Number});
            }
        }

        public function readExternal(input:IDataInput):void {
            __initialized = input.readObject() as Boolean;
            __detachedState = input.readObject() as String;
            if (meta::isInitialized()) {
                _errorNo = input.readObject() as String;
                _errorText = input.readObject() as String;
                _id = function(o:*):Number { return (o is Number ? o as Number : Number.NaN) } (input.readObject());
            }
            else {
                _id = function(o:*):Number { return (o is Number ? o as Number : Number.NaN) } (input.readObject());
            }
        }

        public function writeExternal(output:IDataOutput):void {
            output.writeObject(__initialized);
            output.writeObject(__detachedState);
            if (meta::isInitialized()) {
                output.writeObject((_errorNo is IPropertyHolder) ? IPropertyHolder(_errorNo).object : _errorNo);
                output.writeObject((_errorText is IPropertyHolder) ? IPropertyHolder(_errorText).object : _errorText);
                output.writeObject((_id is IPropertyHolder) ? IPropertyHolder(_id).object : _id);
            }
            else {
                output.writeObject(_id);
            }
        }
    }
}