#import "HashTagsCategory.h"

@implementation HashTagsCategory

@synthesize hashTagSections, name, isSectionsSortedAlphabetically;

- (id)initWithName:()sectionName andHashTagSections:(NSArray *)theHashTagSections andIsSectionsSortedAlphabetically:(BOOL)isHashTagsSectionsSortedAlphabetically{
	if(self == [super init]){
		self.name = sectionName;
		self.hashTagSections = theHashTagSections;
        self.isSectionsSortedAlphabetically = isHashTagsSectionsSortedAlphabetically;
	}
	return self;
}

- (void)dealloc {
	[name release];
	[hashTagSections release];
	[super dealloc];
}

@end
