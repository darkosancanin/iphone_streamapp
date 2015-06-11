#import <Foundation/Foundation.h>
#import "TouchableImageView.h"

@interface UserInfoHeaderView : UIControl {
	NSString *fullName;
	NSString *userName;
	NSString *profileImageUrl;
	BOOL displayAccessoryArrow;
    TouchableImageView *profileImageView;
    UILabel *fullNameLabel;
    UILabel *userNameLabel;
    id profileImageTouchTarget;
    SEL profileImageTouchAction;
    
}

- (id)initWithFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl andDisplayAccessoryArrow:(BOOL)displayAccessoryArrow;
- (void)updateFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl;
- (void)setUpViews;
- (void)updateViews;
- (void)addProfileImageTouchEventTarget:(id)target action:(SEL)action;

@end
