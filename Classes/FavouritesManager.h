#import <Foundation/Foundation.h>
#import "User.h"

@interface FavouritesManager : NSObject {
}

+ (FavouritesManager *)shared;

- (void)addUserToFavourites:(NSString *)userName;
- (void)removeUserFromFavourites:(NSString *)userName;
- (NSArray *)getFavouriteUserNames;
- (BOOL)isUserAFavourite:(NSString *)userName;
- (BOOL)favouritesHaveBeenSelected;
- (void)resetAllSettings;

@end
