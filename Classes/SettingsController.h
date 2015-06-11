#import <UIKit/UIKit.h>
#import "FontSizeSelectionControllerDelegate.h"
#import "UpdateManagerDelegate.h"
#import "MessageView.h"

@interface SettingsController : UITableViewController<FontSizeSelectionControllerDelegate, UIAlertViewDelegate, UpdateManagerDelegate> {
    MessageView *messageView;
}

@end
