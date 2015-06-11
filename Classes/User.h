#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface User : NSObject {
	NSString *userName;
	NSString *fullName;
	NSString *profileImageUrl;
    NSString *url;
    NSString *bio;
    NSString *location;
    BOOL verified;
    unsigned long numberOfTweets;
    unsigned long numberOfFollowers;
}

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *profileImageUrl;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *url;
@property (nonatomic) BOOL verified;
@property (nonatomic) unsigned long numberOfTweets;
@property (nonatomic) unsigned long numberOfFollowers;

- (id)initWithFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl andLocation:(NSString *)theLocation andBio:(NSString *)theBio andVerified:(BOOL)isVerified andNumberOfTweets:(unsigned long)theNumberOfTweets andNumberOfFollowers:(unsigned long)theNumberOfFollowers andUrl:(NSString *)theUrl;
- (id)initWithFullName:(NSString *)theFullName andUserName:(NSString *)theUserName;
- (id)initWithUserName:(NSString *)theUserName;
- (id)initWithTweet:(Tweet *)theTweet;
- (NSString *)getFullNameOrUsername;

@end
