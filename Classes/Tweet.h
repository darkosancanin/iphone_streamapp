#import <Foundation/Foundation.h>

typedef unsigned long long TweetID;

@interface Tweet : NSObject {
	unsigned long long tweetId;
	NSString *text;
	NSString *userName;
	NSString *fullName;
	NSString *profileImageUrl;
    NSString *toUserName;
	NSDate *createdDate;
	NSDateFormatter *outputDateFormatter;
}

@property unsigned long long tweetId;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *profileImageUrl;
@property (nonatomic, retain) NSDate *createdDate;
@property (nonatomic, retain) NSString *toUserName;

- (id)initWithTweetId:(unsigned long long)theTweetId andFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl andText:(NSString *)theText andDateCreated:(NSString *)dateCreatedAsString andDateCreatedFormat:(NSString *)dateCreatedFormat andToUserName:(NSString *)theToUserName;
- (NSString *)createdDateLongFormat;
- (NSString *)createdDateShortFormat;
- (NSString *)formattedText;
- (NSString *)getFullNameOrUsername;

@end
