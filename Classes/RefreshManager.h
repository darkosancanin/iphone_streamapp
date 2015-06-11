#import <Foundation/Foundation.h>

@interface RefreshManager : NSObject {
    BOOL streamsScreenNeedsRefreshing;
    BOOL hashTagsScreenNeedsRefreshing;
    BOOL favouritesScreenNeedsRefreshing;
    BOOL tweetListScreenNeedsRefreshing;
    BOOL tweetScreenNeedsRefreshing;
    BOOL myStreamScreenNeedsRefreshing;
}

@property (nonatomic) BOOL streamsScreenNeedsRefreshing;
@property (nonatomic) BOOL tweetListScreenNeedsRefreshing;
@property (nonatomic) BOOL tweetScreenNeedsRefreshing;
@property (nonatomic) BOOL hashTagsScreenNeedsRefreshing;
@property (nonatomic) BOOL favouritesScreenNeedsRefreshing;
@property (nonatomic) BOOL myStreamScreenNeedsRefreshing;

+ (RefreshManager *)shared;

@end
