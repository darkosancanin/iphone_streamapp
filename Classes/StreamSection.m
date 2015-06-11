#import "StreamSection.h"

@implementation StreamSection

@synthesize streams, name;

- (id)initWithName:()sectionName andStreams:(NSArray *)theStreams{
	if(self == [super init]){
		self.name = sectionName;
		self.streams = theStreams;
	}
	return self;
}

- (BOOL)hasVisibleName{
    return self.name.length > 0 && ![self.name isEqualToString:@" "];
}

- (void)dealloc {
	[name release];
	[streams release];
	[super dealloc];
}

@end
