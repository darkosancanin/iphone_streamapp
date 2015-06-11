#import <Foundation/Foundation.h>

@protocol FontSizeSelectionControllerDelegate <NSObject>

@required
- (void)didSelectFontSizeOf:(int)fontSize forPropertyName:(NSString *)propertyName;

@end