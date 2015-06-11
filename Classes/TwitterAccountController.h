#import <Foundation/Foundation.h>
#import "TwitterAccountManagerDelegate.h"
#import "MessageView.h"

@interface TwitterAccountController : UITableViewController<TwitterAccountManagerDelegate, UITextFieldDelegate> {
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    MessageView *messageView;
}

- (void)setUpMessageView;
- (void)setUpNavigationButtons;
- (void)updateNavigationButton;
- (void)setUpCreateAccountText;
- (void)setCreateTextAccountFooterVisiblity;

@end
