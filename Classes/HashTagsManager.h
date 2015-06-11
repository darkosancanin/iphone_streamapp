#import <Foundation/Foundation.h>
#import "HashTagCollection.h"

@interface HashTagsManager : NSObject {
}

+ (HashTagsManager *)shared;

- (NSArray *)getHashTagsCategories;

@end
