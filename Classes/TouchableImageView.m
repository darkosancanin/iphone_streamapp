#import "TouchableImageView.h"

@implementation TouchableImageView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(touchAction){
        [touchTarget performSelector:touchAction];
    }
}

- (void)addTouchEventTarget:(id)target action:(SEL)action{
    touchAction = action;
    touchTarget = target;
}

@end
