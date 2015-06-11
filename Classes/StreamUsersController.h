#import <UIKit/UIKit.h>
#import "Stream.h"
#import "User.h"

@interface StreamUsersController : UITableViewController {
    Stream *stream;
}

@property (nonatomic, retain) Stream *stream;

- (id)initWithStream:(Stream *)theStream;

@end
