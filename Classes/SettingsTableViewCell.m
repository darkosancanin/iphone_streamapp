#import "SettingsTableViewCell.h"
#import "Global.h"

@implementation SettingsTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow.png"]];
        self.accessoryView = accessoryView;
        [accessoryView release];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        NSArray *onOffItems = [NSArray arrayWithObjects:@"On", @"Off", nil];
        onOffSegmentedControl = [[UISegmentedControl alloc] initWithItems:onOffItems];
        onOffSegmentedControl.frame = CGRectMake(190, 8, 100, 30);
        onOffSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        onOffSegmentedControl.tintColor = [UIColor grayColor];
        [onOffSegmentedControl addTarget:self action:@selector(onOffSegmentedControlClicked) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:onOffSegmentedControl];
        
        extraDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 15, 150, 14)];
        extraDetailLabel.backgroundColor = [UIColor clearColor];
        extraDetailLabel.font = [UIFont systemFontOfSize:13];
        extraDetailLabel.textColor = [UIColor whiteColor];
        extraDetailLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:extraDetailLabel];
    }
    return self;
}

- (void)onOffSegmentedControlClicked{
    if(onOffSegmentedControlTarget){
        [onOffSegmentedControlTarget performSelector:onOffSegmentedControlSelector withObject:onOffSegmentedControl];
    }
}

- (void)accessoryViewIsVisible:(BOOL)accessoryViewIsVisible{
    accessoryView.hidden = !accessoryViewIsVisible;
    CGFloat extraDetailLabelXCoordinate = 115;
    if(!accessoryViewIsVisible) extraDetailLabelXCoordinate = 135;
    extraDetailLabel.frame = CGRectMake(extraDetailLabelXCoordinate, extraDetailLabel.frame.origin.y, extraDetailLabel.frame.size.width, extraDetailLabel.frame.size.height);
}

- (void)setExtraDetailLabelIsVisible:(BOOL)extraDetailLabelIsVisible{
    extraDetailLabel.hidden = !extraDetailLabelIsVisible;
}

- (void)setExtraDetailLabelText:(NSString *)newText{
    extraDetailLabel.text = newText;
}

- (void)setOnOffSegmentedControlTarget:(id)newTarget andSelector:(SEL)newSelector{
    onOffSegmentedControlTarget = newTarget;
    onOffSegmentedControlSelector = newSelector;
}

- (void)setOnOffSegmentedControlIsVisible:(BOOL)onOffSegmentedControlIsVisible{
    onOffSegmentedControl.hidden = !onOffSegmentedControlIsVisible;
}

- (void)setOnOffSegmentedControlIsOn:(BOOL)isOn{
    if(isOn){
        onOffSegmentedControl.selectedSegmentIndex = 0;
    }
    else{
        onOffSegmentedControl.selectedSegmentIndex = 1;
    }

}

- (void)setText:(NSString *)newText{
    self.textLabel.text = newText;
}

- (void)dealloc
{
    [extraDetailLabel release];
    [onOffSegmentedControl release];
    [accessoryView release];
    [super dealloc];
}

@end
