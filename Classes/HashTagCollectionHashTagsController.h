#import <UIKit/UIKit.h>
#import "HashTagCollection.h"
#import "User.h"

@interface HashTagCollectionHashTagsController : UITableViewController {
    HashTagCollection *hashTagCollection;
}

@property (nonatomic, retain) HashTagCollection *hashTagCollection;

- (id)initWithHashTagCollection:(HashTagCollection *)theHashTagCollection;

@end
