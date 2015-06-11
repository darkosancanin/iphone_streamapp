#import "StreamAppAppDelegate.h"
#import "UpdateManager.h"
#import "AutoUpdateOperation.h"
#import "SDImageCache.h"
#import "GANTracker.h"
#import "ApplicationSettings.h"

#define ONE_DAY_IN_SECONDS 86400

@implementation StreamAppAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize operationQueue;

#pragma mark -
#pragma mark Application lifecycle

- (id)init
{
    if (![super init]) return nil;
    operationQueue = [[NSOperationQueue alloc] init];
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    tabBarController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    tabBarController.moreNavigationController.navigationBar.tintColor = [UIColor blackColor];
    tabBarController.delegate = self;
    
    NSError *error;
	[[GANTracker sharedTracker] startTrackerWithAccountID:GOOGLE_ANALYTICS_NUMBER dispatchPeriod:10 delegate:nil];
	if (![[GANTracker sharedTracker] trackPageview:@"/application_start_screen" withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}

    [window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)checkForApplicationDataUpdate{
    UpdateManager *updateManager = [UpdateManager shared];
    if(updateManager.autoUpdate){
        NSDate *lastUpdateCheck = updateManager.dateOfLastUpdateCheck;
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval intervalSinceLastUpdateCheck = [now timeIntervalSinceDate:lastUpdateCheck];
        
        if (!lastUpdateCheck || intervalSinceLastUpdateCheck > ONE_DAY_IN_SECONDS) {
            AutoUpdateOperation *autoUpdateOperation = [[AutoUpdateOperation alloc] init];
            [operationQueue addOperation:autoUpdateOperation];
            [autoUpdateOperation release];
        }
    }
}

- (void)tabBarController:(UITabBarController *)controller willBeginCustomizingViewControllers:(NSArray *)viewControllers {
    UIView *editView = [controller.view.subviews objectAtIndex:1];
    UINavigationBar *modalNavBar = [editView.subviews objectAtIndex:0];
    modalNavBar.tintColor = [UIColor blackColor];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self checkForApplicationDataUpdate];
    NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:@"Application" action:@"Activated" label:@"" value:-1 withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];
}


- (void)dealloc {
    [[GANTracker sharedTracker] stopTracker];
    [operationQueue release];
	[tabBarController release];
    [window release];
    [super dealloc];
}


@end
