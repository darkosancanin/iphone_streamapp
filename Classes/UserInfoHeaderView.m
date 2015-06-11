#import <QuartzCore/QuartzCore.h>
#import "UserInfoHeaderView.h"
#import "UIImageView+WebCache.h"
#import "Global.h"

@implementation UserInfoHeaderView

- (id)initWithFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl andDisplayAccessoryArrow:(BOOL)shouldDisplayAccessoryArrow{
	if(self == [super init]){
		fullName = [theFullName copy];
		userName = [theUserName copy];
		profileImageUrl = [theProfileImageUrl copy];
		displayAccessoryArrow = shouldDisplayAccessoryArrow;
		[self setUpViews];
	}
	return self;
}

- (void)setUpViews{
	self.frame = CGRectMake(0, 0, 320, 80);
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 70)];
	backgroundView.userInteractionEnabled = NO;
	backgroundView.backgroundColor = [UIColor blackColor];
	backgroundView.layer.cornerRadius = 10.0;
	backgroundView.alpha = ALPHA_LEVEL;
	[self addSubview:backgroundView];
	[backgroundView release];
	
	profileImageView = [[TouchableImageView alloc] initWithFrame:CGRectMake(20, 16, 48, 48)];
	profileImageView.layer.cornerRadius = 10.0;
	profileImageView.layer.masksToBounds = YES;
	profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
	profileImageView.layer.borderWidth = 1.0;
    [profileImageView addTouchEventTarget:self action:@selector(profileImageViewClicked)];
	[self addSubview:profileImageView];
	
	if(displayAccessoryArrow){
		UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(282, 33, 15, 15)];
		arrowImageView.image = [UIImage imageNamed:@"accessory_arrow.png"];
		[self addSubview:arrowImageView];
		[arrowImageView release];
	}
	
    fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 187, 21)];
    fullNameLabel.backgroundColor = [UIColor clearColor];
    fullNameLabel.font = [UIFont boldSystemFontOfSize:18];
    fullNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:fullNameLabel];
	
	userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 43, 187, 21)];
	userNameLabel.backgroundColor = [UIColor clearColor];
	userNameLabel.textColor = [UIColor whiteColor];
	[self addSubview:userNameLabel];
    
    [self updateViews];
}

- (void)addProfileImageTouchEventTarget:(id)target action:(SEL)action{
    profileImageTouchTarget = target;
    profileImageTouchAction = action;
    profileImageView.multipleTouchEnabled = YES;
    profileImageView.userInteractionEnabled = YES;
}

- (void)profileImageViewClicked{
    if(profileImageTouchTarget){
        [profileImageTouchTarget performSelector:profileImageTouchAction];  
    }
}

- (void)updateFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl{
    fullName = theFullName;
    userName = theUserName;
    profileImageUrl = theProfileImageUrl;
    [self updateViews];
}

- (void)updateViews{
    [profileImageView setImageWithURL:[NSURL URLWithString:profileImageUrl]
					 placeholderImage:[UIImage imageNamed:@"profile_image_placeholder.png"]];
    fullNameLabel.text = fullName;
    userNameLabel.text = [NSString stringWithFormat:@"@%@", userName];
    
    CGRect userNameFrame = CGRectMake(80, 43, 187, 21);
    UIFont *userNameFont = [UIFont systemFontOfSize:14];
    if(!fullName){
        userNameFrame = CGRectMake(80, 30, 187, 21);
        userNameFont = [UIFont boldSystemFontOfSize:18];
    }
    userNameLabel.frame = userNameFrame;
    userNameLabel.font = userNameFont;
}

- (void)dealloc {
    [userNameLabel release];
    [fullNameLabel release];
    [profileImageView release];
	[fullName release];
	[userName release];
	[profileImageUrl release];
	[super dealloc];
}

@end
