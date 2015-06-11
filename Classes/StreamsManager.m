#import "StreamsManager.h"
#import "Stream.h"
#import "StreamSection.h"
#import "StreamCategory.h"
#import "ApplicationDataManager.h"
#import "User.h"

@implementation StreamsManager

- (id)init {
	if(self == [super init]){
	}
	return self;
}

+ (StreamsManager *)shared
{
	static StreamsManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[StreamsManager alloc] init];
		}
		return sharedSingleton;
	}
}

- (NSArray *)getStreamCategories{
	ApplicationDataManager *applicationDataManager = [ApplicationDataManager shared];
    NSMutableDictionary *userFullNameLookup = [[NSMutableDictionary alloc] init];
    NSArray *streamCategoriesData = [[applicationDataManager applicationData ] objectForKey:@"stream_categories"];
    NSMutableArray *streamCategories = [[NSMutableArray alloc] initWithCapacity:streamCategoriesData.count];
    for (NSDictionary *streamCategory in streamCategoriesData) {
        NSString *streamCategoryName = [streamCategory objectForKey:@"name"];
        BOOL isSectionsSortedAlphabetically = [[streamCategory objectForKey:@"is_sections_sorted_alphabetically"] boolValue];
        NSArray *streamSectionsData = [streamCategory objectForKey:@"stream_sections"];
        NSMutableArray *streamSections = [[NSMutableArray alloc] initWithCapacity:streamSectionsData.count];
        for (NSDictionary *streamSection in streamSectionsData) {
            NSString *streamSectionName = [streamSection objectForKey:@"name"];
            NSArray *streamsData = [streamSection objectForKey:@"streams"];
            NSMutableArray *streams = [[NSMutableArray alloc] initWithCapacity:streamsData.count];
            for (NSDictionary *stream in streamsData) {
                NSString *streamName = [stream objectForKey:@"name"];
                NSString *streamShortName = [stream objectForKey:@"short_name"];
                NSArray *usersData = [stream objectForKey:@"users"];
                NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:usersData.count];
                for (NSDictionary *user in usersData) {
                    NSString *userUserName = [user objectForKey:@"user_name"];
                    NSString *userFullName = [user objectForKey:@"full_name"];
                    User *user = [[User alloc] initWithFullName:userFullName andUserName:userUserName];
                    [users addObject:user];
                    [user release];
                    [userFullNameLookup setObject:userFullName forKey:[userUserName lowercaseString]];
                }
                Stream *stream = [[Stream alloc] initWithStreamName:streamName andShortName:streamShortName andUsers:users];
                [streams addObject:stream];
                [stream release];
                [users release];
            }
            StreamSection *streamSection = [[StreamSection alloc] initWithName:streamSectionName andStreams:streams];
            [streamSections addObject:streamSection];
            [streamSection release];
            [streams release];
        }
        StreamCategory *streamCategory = [[StreamCategory alloc] initWithName:streamCategoryName andStreamSections:streamSections andIsSectionsSortedAlphabetically:isSectionsSortedAlphabetically];
        [streamCategories addObject:streamCategory];
        [streamCategory release];
        [streamSections release];
    }
	    
    applicationDataManager.userFullNameLookup = userFullNameLookup;
    [userFullNameLookup release];
    
	return [streamCategories autorelease];
}

@end
