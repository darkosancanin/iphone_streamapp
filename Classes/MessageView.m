#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"

@implementation MessageView

- (id)init {
    if (self == [super initWithFrame:CGRectMake(40, 128, 240, 100)]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        self.layer.cornerRadius = 10.0;
        loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 100, 21)];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:loadingActivityIndicator];
        [self addSubview:textLabel];
        loadingActivityIndicator.frame = CGRectMake(0, 39, 20, 20);
        [loadingActivityIndicator startAnimating];
        successImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick.png"]];
        successImage.frame = CGRectMake(0, 39, 16, 16);
        successImage.alpha = 0;
        [self addSubview:successImage];
        
        [self setText:@"Loading..."];
    }
    return self;
}

- (void)setText:(NSString *)newText{
    CGSize textSize = [newText sizeWithFont:[textLabel font]];
    CGFloat textAndIndicatorWidth = textSize.width + 6.0 + loadingActivityIndicator.frame.size.width;
    CGFloat paddingOnEitherSide = (self.frame.size.width - textAndIndicatorWidth) / 2;
    successImage.frame = loadingActivityIndicator.frame = CGRectMake(paddingOnEitherSide, loadingActivityIndicator.frame.origin.y, loadingActivityIndicator.frame.size.width, loadingActivityIndicator.frame.size.height);
    CGFloat textXPosition = paddingOnEitherSide + loadingActivityIndicator.frame.size.width + 6.0;
    textLabel.frame = CGRectMake(textXPosition, textLabel.frame.origin.y, textSize.width, textLabel.frame.size.height);
    textLabel.text = newText;
}

- (void)showLoadingMessage{
    [self showLoadingMessage:@"Loading..."];
}

- (void)showLoadingMessage:(NSString *)loadingMessage{
    [self setText:loadingMessage];
    loadingActivityIndicator.alpha = 1;
    self.alpha = ALPHA_LEVEL;
    successImage.hidden = YES;
}

- (void)hide{
    self.alpha = 0;
}

- (void)showSuccessMessage:(NSString *)successMessage{
    [self setText:successMessage];
    loadingActivityIndicator.alpha = 0;
    self.alpha = ALPHA_LEVEL;
    successImage.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:1.5];
    [UIView setAnimationDuration:0.1];
    self.alpha = 0;
    [UIView commitAnimations];
}

- (void)showLoadingMessageInTableView:(UITableView *)tableView{
    [self showLoadingMessage];
    [self centerInTableView:tableView];
}

- (void)showLoadingMessage:(NSString *)loadingMessage andCenterInTableView:(UITableView *)tableView;
{
    [self showLoadingMessage:loadingMessage];
    [self centerInTableView:tableView];
}

- (void)showSuccessMessage:(NSString *)successMessage andCenterInTableView:(UITableView *)tableView;
{
    [self showSuccessMessage:successMessage];
    [self centerInTableView:tableView];
}

- (void)centerInTableView:(UITableView *)tableView{
    CGFloat y = ((357 - self.frame.size.height) / 2) + tableView.contentOffset.y;
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)dealloc
{
    [successImage release];
    [loadingActivityIndicator release];
    [textLabel release];
    [super dealloc];
}

@end
