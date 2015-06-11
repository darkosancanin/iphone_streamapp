#import "User.h"

@implementation User

@synthesize fullName, userName, profileImageUrl, bio, location, verified, numberOfFollowers, numberOfTweets, url;

- (id)initWithFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl andLocation:(NSString *)theLocation andBio:(NSString *)theBio andVerified:(BOOL)isVerified andNumberOfTweets:(unsigned long)theNumberOfTweets andNumberOfFollowers:(unsigned long)theNumberOfFollowers andUrl:(NSString *)theUrl{
    if(self == [super init]){
		self.userName = theUserName;
		self.fullName = theFullName;
		self.profileImageUrl = theProfileImageUrl;
        self.bio = theBio;
        self.location = theLocation;
        self.verified = isVerified;
        self.numberOfTweets = theNumberOfTweets;
        self.numberOfFollowers = theNumberOfFollowers;
        self.url = theUrl;
	}
	return self;
}

- (id)initWithFullName:(NSString *)theFullName andUserName:(NSString *)theUserName{
    if(self == [super init]){
        self.fullName = theFullName;
		self.userName = theUserName;
	}
	return self;
}

- (id)initWithUserName:(NSString *)theUserName{
    if(self == [super init]){
		self.userName = theUserName;
	}
	return self;
}

- (id)initWithTweet:(Tweet *)theTweet{
    if(self == [super init]){
		self.userName = theTweet.userName;
		self.fullName = theTweet.fullName;
		self.profileImageUrl = theTweet.profileImageUrl;
	}
	return self;
}

- (NSString *)getFullNameOrUsername{
	if(!fullName) return userName;
	return fullName;
}

- (void)dealloc {
    [url release];
    [bio release];
    [location release];
	[profileImageUrl release];
	[userName release];
	[fullName release];
	[super dealloc];
}

@end
