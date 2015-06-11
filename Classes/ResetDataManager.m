#import "ResetDataManager.h"
#import "SettingsManager.h"
#import "FavouritesManager.h"
#import "UpdateManager.h"
#import "TwitterAccountManager.h"

@implementation ResetDataManager

+ (ResetDataManager *)shared
{
	static ResetDataManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[ResetDataManager alloc] init];
		}
		return sharedSingleton;
	}
}

- (void)resetData{
    [[SettingsManager shared] resetAllSettings];
    [[FavouritesManager shared] resetAllSettings];
    [[UpdateManager shared] resetAllSettings];
    [[TwitterAccountManager shared] resetAllSettings];
}

- (void)dealloc{
    [super dealloc];
}

@end
