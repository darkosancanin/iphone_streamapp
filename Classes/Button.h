#import <Foundation/Foundation.h>

@interface Button : UIButton {
    UIImageView *favouritesStarImageView;
}

@property (nonatomic, retain) UIImageView *favouritesStarImageView;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
- (void)setUpLabel;
- (void)showFavouritesStar;
- (void)showBlankFavouritesStar;

@end
