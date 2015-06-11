#import <Foundation/Foundation.h>
#import "TweetsController.h"

@interface SearchController : TweetsController<UISearchBarDelegate> {
    BOOL shouldLoadTweets;
    UISearchBar *searchBar;
}

@property (nonatomic, retain) UISearchBar *searchBar;

- (id)initWithSearchTerm:(NSString *)theSearchTerm;
- (void)setUpSearchBox;

@end
