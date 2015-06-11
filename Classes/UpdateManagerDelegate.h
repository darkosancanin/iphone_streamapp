#import <Foundation/Foundation.h>

@protocol UpdateManagerDelegate <NSObject>

@required
- (void)updateManagerDidFinishUpdating;
- (void)updateManagerDidFinishWithNoNewUpdates;
- (void)updateManagerDidFailToUpdateWithError:(NSString *)errorMessage;

@end