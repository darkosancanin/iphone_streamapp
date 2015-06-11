#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h> 

@interface InfoController : UIViewController<MFMailComposeViewControllerDelegate> {
    IBOutlet UIView *headerView;
    IBOutlet UIView *textViewBackground;
}

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIView *textViewBackground;

- (void)setUpViews;
- (void)addButtons;

@end
