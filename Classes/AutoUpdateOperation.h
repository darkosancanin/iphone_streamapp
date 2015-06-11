#import <Foundation/Foundation.h>
#import "UpdateManager.h"

@interface AutoUpdateOperation : NSOperation<UpdateManagerDelegate> {
}

- (void)checkForUpdates;

@end
