#import "TweetTypeDetails.h"

@implementation TweetTypeDetails;

@synthesize tweetType, stream, hashTag, user, hashTagCollection, searchTerm;

- (id)initWithStream:(Stream *)theStream{
	if(self == [super init]){
		self.stream = theStream;
		tweetType = TweetTypeStream;
	}
	return self;
}

- (id)initWithAUser:(User *)theUser{
	if(self == [super init]){
		self.user = theUser;
		tweetType = TweetTypeUser;
	}
	return self;
}

- (id)initAsFavourites{
	if(self == [super init]){
		tweetType = TweetTypeFavourites;
	}
	return self;
}

- (id)initAsMyStream{
	if(self == [super init]){
		tweetType = TweetTypeMyStream;
	}
	return self;
}

- (id)initAsSearch{
	if(self == [super init]){
		tweetType = TweetTypeSearch;
        self.searchTerm = @"";
	}
	return self;
}

- (id)initWithSearchTerm:(NSString *)theSearchTerm{
	if(self == [super init]){
		self.searchTerm = theSearchTerm;
		tweetType = TweetTypeSearch;
	}
	return self;
}

- (id)initWithHashTag:(NSString *)theHashTag{
	if(self == [super init]){
		self.hashTag = theHashTag;
		tweetType = TweetTypeHashTag;
	}
	return self;
}

- (id)initWithHashTagCollection:(HashTagCollection *)thehashTagCollection{
	if(self == [super init]){
		self.hashTagCollection = thehashTagCollection;
		tweetType = TweetTypeHashTagCollection;
	}
	return self;
}

- (void)dealloc {
    [hashTagCollection release];
    [user release];
    [hashTag release];
	[stream release];
	[super dealloc];
}

@end
