#import "RefreshManager.h"

@implementation RefreshManager

@synthesize streamsScreenNeedsRefreshing, hashTagsScreenNeedsRefreshing, favouritesScreenNeedsRefreshing, tweetListScreenNeedsRefreshing, tweetScreenNeedsRefreshing, myStreamScreenNeedsRefreshing;

+ (RefreshManager *)shared
{
	static RefreshManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[RefreshManager alloc] init];
		}
		return sharedSingleton;
	}
}

@end
