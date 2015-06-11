#import <Foundation/Foundation.h>
#import "TweetsController.h"

@interface MyStreamController : TweetsController {
    UIView *notAuthenticatedMessageView;
}

@property (nonatomic, retain) UIView *notAuthenticatedMessageView;

- (void)setUpComposeButton;

@end
