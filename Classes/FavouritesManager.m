#import "FavouritesManager.h"
#import "RefreshManager.h"

#define FAVOURITES_KEY_NAME @"favourites_usernames"

@implementation FavouritesManager

- (id)init {
	if(self == [super init]){
	}
	return self;
}

+ (FavouritesManager *)shared
{
	static FavouritesManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[FavouritesManager alloc] init];
		}
		return sharedSingleton;
	}
}

- (void)addUserToFavourites:(NSString *)userName{
    NSArray *existingFavouriteUserNames = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVOURITES_KEY_NAME];
	NSMutableArray *favouriteUserNames = [[NSMutableArray alloc] init];
	if(existingFavouriteUserNames){
		[favouriteUserNames addObjectsFromArray:existingFavouriteUserNames];
	}
	[favouriteUserNames addObject:[userName lowercaseString]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:favouriteUserNames] forKey:FAVOURITES_KEY_NAME];
	[favouriteUserNames release];
    [[RefreshManager shared] setFavouritesScreenNeedsRefreshing:YES];
}

- (void)removeUserFromFavourites:(NSString *)userName{
    NSArray *existingFavouriteUserNames = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVOURITES_KEY_NAME];
	NSMutableArray *favouriteUserNames = [[NSMutableArray alloc] initWithArray:existingFavouriteUserNames];
	[favouriteUserNames removeObject:[userName lowercaseString]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:favouriteUserNames] forKey:FAVOURITES_KEY_NAME];
	[favouriteUserNames release];
    [[RefreshManager shared] setFavouritesScreenNeedsRefreshing:YES];
}

- (NSArray *)getFavouriteUserNames{
    NSArray *existingFavouriteUserNames = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVOURITES_KEY_NAME];
    if(existingFavouriteUserNames) {
        return existingFavouriteUserNames;
    }
    else{
        return [[[NSArray alloc] init] autorelease];
    }
}

- (BOOL)favouritesHaveBeenSelected{
    NSArray *favouriteUserNames = [self getFavouriteUserNames];
    return (favouriteUserNames.count > 0);
}

- (BOOL)isUserAFavourite:(NSString *)userName{
    NSArray *favouriteUserNames = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVOURITES_KEY_NAME];
    if(favouriteUserNames) {
        for(NSString *favouriteUserName in favouriteUserNames){
            if([favouriteUserName isEqualToString:[userName lowercaseString]]){
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)resetAllSettings{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FAVOURITES_KEY_NAME];
    [[RefreshManager shared] setFavouritesScreenNeedsRefreshing:YES];
}

- (void)dealloc{
    [super dealloc];
}

@end
