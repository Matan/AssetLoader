package org.assetloader
{

	import org.assetloader.base.BaseTestSuite;
	import org.assetloader.loaders.LoadersTestSuite;
	import org.assetloader.parsers.ParsersTestSuite;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AssetLoaderTestSuit
	{
		public var baseTestSuite : BaseTestSuite;
		public var loadersTestSuite : LoadersTestSuite;
		public var assetLoaderlTest : AssetLoaderTest;
		public var parsersTestSuite : ParsersTestSuite;
	}
}
