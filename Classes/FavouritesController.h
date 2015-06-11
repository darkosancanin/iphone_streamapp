#import <Foundation/Foundation.h>
#import "TweetsController.h"

@interface FavouritesController : TweetsController {
    UIView *noFavouritesSelectedMessageView;
}

@property (nonatomic, retain) UIView *noFavouritesSelectedMessageView;

@end
