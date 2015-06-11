#import <UIKit/UIKit.h>

@interface StreamAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
    NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

- (void)checkForApplicationDataUpdate;

@end

