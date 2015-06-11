#import "HashTagsSection.h"

@implementation HashTagsSection

@synthesize hashTagCollections, name;

- (id)initWithName:()sectionName andHashTagCollections:(NSArray *)theHashTagCollections{
	if(self == [super init]){
		self.name = sectionName;
		self.hashTagCollections = theHashTagCollections;
	}
	return self;
}

- (BOOL)hasVisibleName{
    return self.name.length > 0 && ![self.name isEqualToString:@" "];
}

- (void)dealloc {
	[name release];
	[hashTagCollections release];
	[super dealloc];
}

@end
