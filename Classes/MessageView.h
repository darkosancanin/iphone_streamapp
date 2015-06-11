#import <UIKit/UIKit.h>

@interface MessageView : UIView {
    UILabel *textLabel;
    UIActivityIndicatorView *loadingActivityIndicator;
    UIImageView *successImage;
}

- (id)init;
- (void)hide;
- (void)setText:(NSString *)newText;
- (void)showLoadingMessage;
- (void)showLoadingMessage:(NSString *)loadingMessage;
- (void)showSuccessMessage:(NSString *)successMessage;
- (void)showLoadingMessageInTableView:(UITableView *)tableView;
- (void)showLoadingMessage:(NSString *)loadingMessage andCenterInTableView:(UITableView *)tableView;
- (void)showSuccessMessage:(NSString *)successMessage andCenterInTableView:(UITableView *)tableView;
- (void)centerInTableView:(UITableView *)tableView;

@end
