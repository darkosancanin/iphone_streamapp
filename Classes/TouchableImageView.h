#import <Foundation/Foundation.h>

@interface TouchableImageView : UIImageView {
    id touchTarget;
    SEL touchAction;
}

- (void)addTouchEventTarget:(id)target action:(SEL)action;

@end
