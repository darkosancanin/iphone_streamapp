#import <UIKit/UIKit.h>
#import "FontSizeSelectionControllerDelegate.h"

@interface FontSizeSelectionController : UITableViewController {
    id<FontSizeSelectionControllerDelegate> delegate;
    NSString *propertyName;
    NSMutableArray *fontSizes;
    int currentValue;
}

@property (nonatomic, assign) id<FontSizeSelectionControllerDelegate> delegate;
@property (nonatomic, retain) NSString *propertyName;

- (id)initWithPropertyName:(NSString *)thePropertyName andMinSize:(int)theMinSize andMaxSize:(int)theMaxSize andCurrentValue:(int)theCurrentValue andDelegate:(id<FontSizeSelectionControllerDelegate>)theDelegate;

@end
