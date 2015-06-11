#import "HashTagCollection.h"

@implementation HashTagCollection

@synthesize hashTags, name, shortName;

- (id)initWithName:()hashTagCollectionName andShortName:(NSString *)hashTagCollectionShortName andHashTags:(NSArray *)theHashTags{
	if(self == [super init]){
		self.name = hashTagCollectionName;
        self.shortName = hashTagCollectionShortName;
		self.hashTags = theHashTags;
	}
	return self;
}

- (void)dealloc {
    [shortName release];
	[name release];
	[hashTags release];
	[super dealloc];
}

@end
