package org.assetloader.base
{
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class BaseTestSuite
	{
		public var abstractLoaderTest : AbstractLoaderTest;
				public var assetLoaderQueueTest : AssetLoaderQueueTest;
				public var assetLoaderErrorTest : AssetLoaderErrorTest;
				public var loaderFactoryTest : LoaderFactoryTest;
				public var loaderStatsTest : LoaderStatsTest;
		
		public var statsMonitorTest : StatsMonitorTest;
				public var paramTest : ParamTest;	}
}
