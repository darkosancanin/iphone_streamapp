#import <UIKit/UIKit.h>
#import "Tweet.h"

typedef enum  {
    TweetTableViewCellAlignmentLeft = 0,
    TweetTableViewCellAlignmentRight = 1
} TweetTableViewCellAlignment;

@interface TweetTableViewCell : UITableViewCell {
	UILabel *textLabel;
	UILabel *fullNameLabel;
	UILabel *screenNameLabel;
	UILabel *dateLabel;
	UIImageView *topBubbleImageView;
	UIImageView *middleBubbleImageView;
	UIImageView *bottomBubbleImageView;
	UIImageView *profileImageView;
	Tweet *tweet;
	TweetTableViewCellAlignment alignment;
}

@property (nonatomic) TweetTableViewCellAlignment alignment;

+ (CGFloat) cellHeightForTweet:(Tweet *) tweetToDisplay;

- (CGFloat) textLabelHeightForText:(NSString *) textToDisplay;
- (void)setTweet:(Tweet *)newTweet andAlignment:(TweetTableViewCellAlignment)newAlignment;

@end
