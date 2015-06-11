#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell {
    UIImageView *accessoryView;
    UISegmentedControl *onOffSegmentedControl;
    id onOffSegmentedControlTarget;
    SEL onOffSegmentedControlSelector;
    UILabel *extraDetailLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)accessoryViewIsVisible:(BOOL)accessoryViewIsVisible;
- (void)setText:(NSString *)newText;
- (void)setExtraDetailLabelIsVisible:(BOOL)extraDetailLabelIsVisible;
- (void)setExtraDetailLabelText:(NSString *)newText;
- (void)setOnOffSegmentedControlIsVisible:(BOOL)onOffSegmentedControlIsVisible;
- (void)setOnOffSegmentedControlIsOn:(BOOL)isOn;
- (void)setOnOffSegmentedControlTarget:(id)newTarget andSelector:(SEL)newSelector;

@end
