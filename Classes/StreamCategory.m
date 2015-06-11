#import "StreamCategory.h"

@implementation StreamCategory

@synthesize streamSections, name, isSectionsSortedAlphabetically;

- (id)initWithName:()categoryName andStreamSections:(NSArray *)theStreamSections andIsSectionsSortedAlphabetically:(BOOL)isStreamSectionsSortedAlphabetically{
	if(self == [super init]){
		self.name = categoryName;
		self.streamSections = theStreamSections;
        self.isSectionsSortedAlphabetically = isStreamSectionsSortedAlphabetically;
	}
	return self;
}

- (void)dealloc {
	[name release];
	[streamSections release];
	[super dealloc];
}

@end
