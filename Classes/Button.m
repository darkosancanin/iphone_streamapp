#import "Button.h"
#import "Global.h"

@implementation Button

@synthesize favouritesStarImageView;

- (void)viewDidLoad {
    [self setUpLabel];
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    if (self == [super initWithFrame:frame]) {
        [self setUpLabel];
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (void)setUpLabel {
    [self setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.alpha = ALPHA_LEVEL;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)showFavouritesStar{
    self.favouritesStarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favouritesstar.png"]];
    self.favouritesStarImageView.frame = CGRectMake(22, 15, 16, 16);
    [self addSubview:self.favouritesStarImageView];
}

- (void)showBlankFavouritesStar{
    self.favouritesStarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favouritesblankstar.png"]];
    self.favouritesStarImageView.frame = CGRectMake(22, 15, 16, 16);
    [self addSubview:self.favouritesStarImageView];
}

- (void)dealloc{
    [favouritesStarImageView release];
    [super dealloc];
}

@end
