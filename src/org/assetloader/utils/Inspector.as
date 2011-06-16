package org.assetloader.utils
{
	import flash.media.Sound;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.text.Font;

	/**
	 * The Incpector class allows you to easily extract assets from a display object's application domain. E.g.
	 * you've just loaded in a swf that contains serveral assets/classes you'd like to use in your application.
	 * By constructing an Inspector instance and passing you loaded swf, you are able to "extact" those assets
	 * just by calling the related api while passing the package/class name.
	 * 
	 * @author Matan Uberstein + Karl Freeman
	 */
	public class Inspector
	{
		/**
		 * @private
		 * Domain used so that we can check to see if a class exhists
		 */
		protected var _domain : ApplicationDomain;

		/**
		 * Public property of the base package used for all future "get" calls.
		 * e.g. Setting the basePackage to "com.domain.assets" and then calling
		 * "getSprite('MyCustomSpriteAsset');" will result in the Inspector returing
		 * a new Sprite instance of "com.domain.assets.MyCustomSpriteAsset".
		 */
		public var basePackage : String = "";

		/**
		 * Constructor.
		 * 
		 * @param displayObject The application domain to be inspected.
		 * 
		 * @see #destroy()
		 */
		public function Inspector(displayObject : DisplayObject)
		{
			_domain = displayObject.loaderInfo.applicationDomain;
		}

		/**
		 * This will get rid of any reference held to the DisplayObject passed via constructor.
		 */
		public function destroy() : void
		{
			_domain = null;
		}

		/**
		 * Extract a Class object from the DisplayObject's application domain.
		 * <p>
		 * <strong>Note:</strong> If you have specified a basePackage and you pass a "full name" of the class you'd like,
		 * the basePackge is STILL appended to the "full name". This is done for performance reasons, there is no need to
		 * do complex String handling. In a case like that, simply set the "overrideBasePackage" to an empty string.
		 * </p>
		 * <ul>
		 * <li><code>inspector.basePackage = "org.assetloader.assets";</code></li>
		 * <li><code>inspector.getClass("MyAsset1"); // Returns the class for "org.assetloader.assets.MyAsset1"</code></li>
		 * <li><code>inspector.getClass("com.domain.assets.MyAsset2", ""); // Returns the class for "com.domain.assets.MyAsset2"</code></li>
		 * <li><code>inspector.getClass("com.domain.assets.MyAsset2"); // Returns the class for "org.assetloader.assets.com.domain.assets.MyAsset2" - which is null</code></li>
		 * </ul>
		 * 
		 * @param classNameOrFullName A straight up class name or full name of a class.
		 * @param overrideBasePackage Override the basePackage, just for this call.
		 * 
		 * @return Class object matching package/name combo.
		 */
		public function getClass(classNameOrFullName : String, overrideBasePackage : String = null) : Class
		{
			var bp : String = overrideBasePackage || basePackage;
			if(!bp) bp = "";
			var fullName : String = bp + ((bp == "") ? "" : ".") + classNameOrFullName;
			if(_domain.hasDefinition(fullName))
				return _domain.getDefinition(fullName) as Class;
			return null;

		}

		/**
		 * Extract a new instance of package/class combo from the DisplayObject's application domain.
		 * 
		 * @param classNameOrFullName A straight up class name or full name of a class.
		 * @param overrideBasePackage Override the basePackage, just for this call.
		 * @see #getClass()
		 */
		public function getSprite(className : String, overrideBasePackage : String = null) : Sprite
		{
			var clazz : Class = getClass(className, overrideBasePackage);
			if(clazz)
				return new clazz() as Sprite;
			return null;
		}

		/**
		 * Extract a new instance of package/class combo from the DisplayObject's application domain.
		 * 
		 * @param classNameOrFullName A straight up class name or full name of a class.
		 * @param overrideBasePackage Override the basePackage, just for this call.
		 * @see #getClass()
		 */
		public function getMovieClip(className : String, overrideBasePackage : String = null) : MovieClip
		{
			var clazz : Class = getClass(className, overrideBasePackage);
			if(clazz)
				return new clazz() as MovieClip;
			return null;
		}

		/**
		 * Extract a new instance of package/class combo from the DisplayObject's application domain.
		 * 
		 * @param classNameOrFullName A straight up class name or full name of a class.
		 * @param overrideBasePackage Override the basePackage, just for this call.
		 * @see #getClass()
		 */
		public function getFont(className : String, overrideBasePackage : String = null) : Font
		{
			var clazz : Class = getClass(className, overrideBasePackage);
			if(clazz)
				return new clazz() as Font;
			return null;
		}

		/**
		 * Extract a new instance of package/class combo from the DisplayObject's application domain.
		 * 
		 * @param classNameOrFullName A straight up class name or full name of a class.
		 * @param overrideBasePackage Override the basePackage, just for this call.
		 * @see #getClass()
		 */
		public function getSound(className : String, overrideBasePackage : String = null) : Sound
		{
			var clazz : Class = getClass(className, overrideBasePackage);
			if(clazz)
				return new clazz() as Sound;
			return null;
		}

		/**
		 * Extract a new instance of package/class combo from the DisplayObject's application domain.
		 * 
		 * @param classNameOrFullName A straight up class name or full name of a class.
		 * @param overrideBasePackage Override the basePackage, just for this call.
		 * @see #getClass()
		 */
		public function getBitmapData(className : String, overrideBasePackage : String = null) : BitmapData
		{
			var clazz : Class = getClass(className, overrideBasePackage);
			if(clazz)
				return new clazz(0, 0) as BitmapData;
			return null;
		}

		/**
		 * Extract a new instance of package/class combo from the DisplayObject's application domain.
		 * 
		 * @param classNameOrFullName A straight up class name or full name of a class.
		 * @param overrideBasePackage Override the basePackage, just for this call.
		 * @see #getClass()
		 */
		public function getBitmap(className : String, overrideBasePackage : String = null) : Bitmap
		{
			var bitmapData : BitmapData = getBitmapData(className, overrideBasePackage);
			if(bitmapData)
				return new Bitmap(bitmapData);
			return null;
		}
	}
}