package org.assetloader.base 
{
	import org.assetloader.core.IAssetParam;

	/**
	 * @author Matan Uberstein
	 */
	public class AssetParam implements IAssetParam
	{
		/**
		 * Adds time stamp to url, which makes each call unique.
		 * Use: All asset types.
		 * Type: <code>Boolean</code>
		 * Default: false
		 */
		public static const PREVENT_CACHE : String = "PREVENT_CACHE";
		
		/**
		 * Amount of times the loading is retried.
		 * Use: All asset types.
		 * Type: <code>unit</code>
		 * Default: 3
		 */		public static const RETRIES : String = "RETRIES";
		
		/**
		 * Sets the <code>URLRequest</code>'s headers.
		 * Use: All asset types except Video.
		 * Type: <code>Array</code>
		 * 
		 * @see flash.net.URLRequestHeader
		 */		public static const HEADERS : String = "HEADERS";
		
		/**
		 * Use: DisplayObject, Image and Swf asset types.
		 * Type: <code>LoaderContext</code>
		 * 
		 * @see flash.system.LoaderContext
		 */		public static const LOADER_CONTEXT : String = "LOADER_CONTEXT";
		
		/**
		 * Sets <code>BitmapData</code>'s transparentcy.
		 * Use: Image asset type.
		 * Type: <code>Boolean</code>
		 * 
		 * @see flash.display.BitmapData
		 */
		public static const TRANSPARENT : String = "TRANSPARENT";
		
		/**
		 * Sets <code>BitmapData</code>'s fill color.
		 * Use: Image asset type.
		 * Type: <code>unit</code>
		 * 
		 * @see flash.display.BitmapData
		 */
		public static const FILL_COLOR : String = "FILL_COLOR";
		
		/**
		 * Sets <code>BitmapData</code>'s matrix.
		 * Use: Image asset type.
		 * Type: <code>Matrix</code>
		 * 
		 * @see flash.geom.Matrix
		 * @see flash.display.BitmapData
		 */
		public static const MATRIX : String = "MATRIX";
		
		/**
		 * Sets <code>BitmapData</code>'s color transform.
		 * Use: Image asset type.
		 * Type: <code>ColorTransform</code>
		 * 
		 * @see flash.geom.ColorTransform
		 * @see flash.display.BitmapData
		 */
		public static const COLOR_TRANSFROM : String = "COLOR_TRANSFROM";
		
		/**
		 * Sets <code>BitmapData</code>'s blend mode.
		 * Use: Image asset type.
		 * Type: <code>String</code>
		 * 
		 * @see flash.display.BlendMode
		 * @see flash.display.BitmapData
		 */
		public static const BLEND_MODE : String = "BLEND_MODE";
		
		/**
		 * Sets <code>BitmapData</code>'s clipping rectangle.
		 * Use: Image asset type.
		 * Type: <code>Rectangle</code>
		 * 
		 * @see flash.geom.Rectangle
		 * @see flash.display.BitmapData
		 */
		public static const CLIP_RECTANGLE : String = "CLIP_RECTANGLE";
		
		/**
		 * Sets <code>Bitmap</code>'s pixel snapping.
		 * Use: Image asset type.
		 * Type: <code>String</code>
		 * 
		 * @see flash.display.Bitmap
		 */
		public static const PIXEL_SNAPPING : String = "PIXEL_SNAPPING";
		
		/**
		 * Sets <code>Bitmap</code> and <code>BitmapData</code>'s smoothing property.
		 * Use: Image asset type.
		 * Type: <code>Boolean</code>
		 * 
		 * @see flash.display.Bitmap
		 * @see flash.display.BitmapData
		 */
		public static const SMOOTHING : String = "SMOOTHING";
		
		/**
		 * Sets <code>Sound</code>'s load context.
		 * Use: Sound asset type.
		 * Type: <code>SoundLoaderContext</code>
		 * 
		 * @see flash.media.SoundLoaderContext
		 */
		public static const SOUND_LOADER_CONTEXT : String = "SOUND_LOADER_CONTEXT";
		
		/**
		 * If <code>NetStream</code> should load cross-domain policy file.
		 * Use: Video asset type.
		 * Type: <code>Boolean</code>
		 * 
		 * @see flash.net.NetStream
		 */
		public static const CHECK_POLICY_FILE : String = "CHECK_POLICY_FILE";

		protected var _id : String;
		protected var _value : *;

		public function AssetParam(id : String, value : *) 
		{
			_id = id;
			_value = value;
		}
		
		public function get id() : String
		{
			return _id;
		}
		
		public function get value() : *
		{
			return _value;
		}
	}
}
