#import <Foundation/Foundation.h>

@interface ResetDataManager : NSObject {
}

+ (ResetDataManager *)shared;

- (void)resetData;

@end