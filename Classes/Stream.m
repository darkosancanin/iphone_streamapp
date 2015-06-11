#import "Stream.h"

@implementation Stream

@synthesize name, shortName, users;

- (id)initWithStreamName:(NSString *)streamName andShortName:(NSString *)streamShortName andUsers:(NSArray *)streamUsers{
	if(self == [super init]){
		self.name = streamName;
		self.shortName = streamShortName;
		self.users = streamUsers;
	}
	return self;
}

- (void)dealloc {
	[name release];
	[shortName release];
	[users release];
	[super dealloc];
}

@end
