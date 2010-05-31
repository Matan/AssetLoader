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
		 * 
		 * <p>Use: All asset types.</p>
		 * <p>Type: <code>Boolean</code></p>
		 * <p>Default: false</p>
		 */
		public static const PREVENT_CACHE : String = "PREVENT_CACHE";

		/**
		 * Amount of times the loading is retried.
		 * 
		 * <p>Use: All asset types.</p>
		 * <p>Type: <code>unit</code></p>
		 * <p>Default: 3</p>
		 */		public static const RETRIES : String = "RETRIES";

		/**
		 * Sets the <code>URLRequest</code>'s headers.
		 * 
		 * <p>Use: All asset types except Video.</p>
		 * <p>Type: <code>Array</code></p>
		 * 
		 * @see flash.net.URLRequestHeader
		 */		public static const HEADERS : String = "HEADERS";

		/**
		 * <p>Use: DisplayObject, Image and Swf asset types.</p>
		 * <p>Type: <code>LoaderContext</code></p>
		 * 
		 * @see flash.system.LoaderContext
		 */		public static const LOADER_CONTEXT : String = "LOADER_CONTEXT";

		/**
		 * Sets <code>BitmapData</code>'s transparentcy.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>Boolean</code></p>
		 * 
		 * @see flash.display.BitmapData
		 */
		public static const TRANSPARENT : String = "TRANSPARENT";

		/**
		 * Sets <code>BitmapData</code>'s fill color.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>unit</code></p>
		 * 
		 * @see flash.display.BitmapData
		 */
		public static const FILL_COLOR : String = "FILL_COLOR";

		/**
		 * Sets <code>BitmapData</code>'s matrix.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>Matrix</code></p>
		 * 
		 * @see flash.geom.Matrix
		 * @see flash.display.BitmapData
		 */
		public static const MATRIX : String = "MATRIX";

		/**
		 * Sets <code>BitmapData</code>'s color transform.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>ColorTransform</code></p>
		 * 
		 * @see flash.geom.ColorTransform
		 * @see flash.display.BitmapData
		 */
		public static const COLOR_TRANSFROM : String = "COLOR_TRANSFROM";

		/**
		 * Sets <code>BitmapData</code>'s blend mode.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>String</code></p>
		 * 
		 * @see flash.display.BlendMode
		 * @see flash.display.BitmapData
		 */
		public static const BLEND_MODE : String = "BLEND_MODE";

		/**
		 * Sets <code>BitmapData</code>'s clipping rectangle.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>Rectangle</code></p>
		 * 
		 * @see flash.geom.Rectangle
		 * @see flash.display.BitmapData
		 */
		public static const CLIP_RECTANGLE : String = "CLIP_RECTANGLE";

		/**
		 * Sets <code>Bitmap</code>'s pixel snapping.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>String</code></p>
		 * 
		 * @see flash.display.Bitmap
		 */
		public static const PIXEL_SNAPPING : String = "PIXEL_SNAPPING";

		/**
		 * Sets <code>Bitmap</code> and <code>BitmapData</code>'s smoothing property.
		 * 
		 * <p>Use: Image asset type.</p>
		 * <p>Type: <code>Boolean</code></p>
		 * 
		 * @see flash.display.Bitmap
		 * @see flash.display.BitmapData
		 */
		public static const SMOOTHING : String = "SMOOTHING";

		/**
		 * Sets <code>Sound</code>'s load context.
		 * 
		 * <p>Use: Sound asset type.</p>
		 * <p>Type: <code>SoundLoaderContext</code></p>
		 * 
		 * @see flash.media.SoundLoaderContext
		 */
		public static const SOUND_LOADER_CONTEXT : String = "SOUND_LOADER_CONTEXT";

		/**
		 * If <code>NetStream</code> should load cross-domain policy file.
		 * 
		 * <p>Use: Video asset type.</p>
		 * <p>Type: <code>Boolean</code></p>
		 * 
		 * @see flash.net.NetStream
		 */
		public static const CHECK_POLICY_FILE : String = "CHECK_POLICY_FILE";

		/**
		 * @private
		 */
		protected var _id : String;

		/**
		 * @private
		 */
		protected var _value : *;

		/**
		 * @param id Param id.
		 * @param value Param value.
		 */
		public function AssetParam(id : String, value : *) 
		{
			_id = id;
			_value = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get id() : String
		{
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		public function get value() : *
		{
			return _value;
		}
	}
}
