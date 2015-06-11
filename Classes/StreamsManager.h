#import <Foundation/Foundation.h>
#import "Stream.h"

@interface StreamsManager : NSObject {
}

+ (StreamsManager *)shared;

- (NSArray *)getStreamCategories;

@end
