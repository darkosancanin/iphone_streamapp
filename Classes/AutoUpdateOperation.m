#import "AutoUpdateOperation.h"

@implementation AutoUpdateOperation

- (void)main {
	@try {
		[self checkForUpdates];
	}
	@catch (NSException *e) {
        NSLog(@"Auto update failed with the following reason: %@", [e reason]);
	}
}

- (void)checkForUpdates{
	UpdateManager *updateManager = [UpdateManager shared];
    updateManager.delegate = self;
    [updateManager checkForUpdatesSynchronously];
}

- (void)updateManagerDidFinishUpdating{
    NSLog(@"Auto update successfully updated the application data.");
}

- (void)updateManagerDidFinishWithNoNewUpdates{
    NSLog(@"Auto update completed with no new updates.");
}

- (void)updateManagerDidFailToUpdateWithError:(NSString *)errorMessage{
    NSLog(@"Auto update failed with the following reason: %@", errorMessage);
}

- (void)dealloc{
	[super dealloc];
}

@end
