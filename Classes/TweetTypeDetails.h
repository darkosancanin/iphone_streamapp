#import <Foundation/Foundation.h>
#import "Tweet.h"
#import "Stream.h"
#import "User.h"
#import "HashTagCollection.h"

typedef enum _TweetType {
	TweetTypeStream = 0,
	TweetTypeHashTag = 1,
    TweetTypeHashTagCollection = 2,
    TweetTypeUser = 3,
    TweetTypeFavourites = 4,
    TweetTypeMyStream = 5,
    TweetTypeSearch = 6
} TweetType;

@interface TweetTypeDetails : NSObject {
	TweetType tweetType;
	Stream *stream;
    User *user;
    NSString *searchTerm;
    NSString *hashTag;
    HashTagCollection *hashTagCollection;
}

@property TweetType tweetType;
@property (nonatomic, retain) Stream *stream;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSString *hashTag;
@property (nonatomic, retain) NSString *searchTerm;
@property (nonatomic, retain) HashTagCollection *hashTagCollection;

- (id)initWithStream:(Stream *)theStream;
- (id)initWithHashTag:(NSString *)theHashTag;
- (id)initWithHashTagCollection:(HashTagCollection *)thehashTagCollection;
- (id)initWithAUser:(User *)theUser;
- (id)initAsFavourites;
- (id)initAsMyStream;
- (id)initAsSearch;
- (id)initWithSearchTerm:(NSString *)theSearchTerm;

@end
