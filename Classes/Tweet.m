#import "Tweet.h"
#import "NSDate+HumanInterval.h"

#define kLongOutputFormat @"EEE, d MMM yyyy h:mm a"

static NSString *justNowText = @"just now";

@implementation Tweet

@synthesize tweetId, text, fullName, userName, profileImageUrl, createdDate, toUserName;

- (id)initWithTweetId:(unsigned long long)theTweetId andFullName:(NSString *)theFullName andUserName:(NSString *)theUserName andProfileImageUrl:(NSString *)theProfileImageUrl andText:(NSString *)theText andDateCreated:(NSString *)dateCreatedAsString andDateCreatedFormat:(NSString *)dateCreatedFormat andToUserName:(NSString *)theToUserName{
	if(self == [super init]){
		self.tweetId = theTweetId;
		self.fullName = theFullName;
		self.userName = theUserName;
		self.profileImageUrl = theProfileImageUrl;
		self.text = theText;
        self.toUserName = theToUserName;
		
		NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
		[inputDateFormatter setDateFormat:dateCreatedFormat];
		self.createdDate = [inputDateFormatter dateFromString:dateCreatedAsString];
		[inputDateFormatter release];
		
		outputDateFormatter = [[NSDateFormatter alloc] init];
	}
	return self;
}

- (NSString *)getFullNameOrUsername{
	if(!fullName) return userName;
	return fullName;
}

- (NSString *)createdDateShortFormat{
    NSString *createdDateAsHumanText = [self.createdDate humanIntervalSinceNow];
    if([createdDateAsHumanText isEqualToString:justNowText]){
        return createdDateAsHumanText;
    }
    else{
        return [[self.createdDate humanIntervalSinceNow] stringByAppendingString:@" ago"];
    }
}

- (NSString *)formattedText{
	return [[[[self.text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""]  stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]  stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
}

- (NSString *)createdDateLongFormat{
	[outputDateFormatter setDateFormat:kLongOutputFormat];
	return [outputDateFormatter stringFromDate:self.createdDate];
}

- (void)dealloc {
    [toUserName release];
	[outputDateFormatter release];
	[text release];
	[fullName release];
	[userName release];
	[profileImageUrl release];
	[createdDate release];
	[super dealloc];
}

@end
