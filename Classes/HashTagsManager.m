#import "HashTagsManager.h"
#import "HashTagCollection.h"
#import "HashTagsSection.h"
#import "HashTagsCategory.h"
#import "ApplicationDataManager.h"
#import "User.h"

@implementation HashTagsManager

- (id)init {
	if(self == [super init]){
	}
	return self;
}

+ (HashTagsManager *)shared
{
	static HashTagsManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[HashTagsManager alloc] init];
		}
		return sharedSingleton;
	}
}

- (NSArray *)getHashTagsCategories{
	ApplicationDataManager *applicationDataManager = [ApplicationDataManager shared];
    NSArray *hashTagCategoriesData = [[applicationDataManager applicationData] objectForKey:@"hashtag_categories"];
    NSMutableArray *hashTagCategories = [[NSMutableArray alloc] initWithCapacity:hashTagCategoriesData.count];
    for (NSDictionary *hashTagCategory in hashTagCategoriesData) {
        NSString *hashTagCategoryName = [hashTagCategory objectForKey:@"name"];
        BOOL isSectionsSortedAlphabetically = [[hashTagCategory objectForKey:@"is_sections_sorted_alphabetically"] boolValue];
        NSArray *hashTagSectionsData = [hashTagCategory objectForKey:@"hashtag_sections"];
        NSMutableArray *hashTagSections = [[NSMutableArray alloc] initWithCapacity:hashTagSectionsData.count];
        for (NSDictionary *hashTagSection in hashTagSectionsData) {
            NSString *hashTagSectionName = [hashTagSection objectForKey:@"name"];
            NSArray *hashTagCollectionsData = [hashTagSection objectForKey:@"hashtag_collections"];
            NSMutableArray *hashTagCollections = [[NSMutableArray alloc] initWithCapacity:hashTagCollectionsData.count];
            for (NSDictionary *hashTagCollection in hashTagCollectionsData) {
                NSString *hashTagCollectionName = [hashTagCollection objectForKey:@"name"];
                NSString *hashTagCollectionShortName = [hashTagCollection objectForKey:@"short_name"];
                NSArray *hashtags = [hashTagCollection objectForKey:@"hashtags"];
                HashTagCollection *hashTagCollection = [[HashTagCollection alloc] initWithName:hashTagCollectionName andShortName:hashTagCollectionShortName andHashTags:hashtags];
                [hashTagCollections addObject:hashTagCollection];
                [hashTagCollection release];
            }
            HashTagsSection *hashTagSection = [[HashTagsSection alloc] initWithName:hashTagSectionName andHashTagCollections:hashTagCollections];
            [hashTagSections addObject:hashTagSection];
            [hashTagSection release];
            [hashTagCollections release];
        }
        HashTagsCategory *hashTagsCategory = [[HashTagsCategory alloc] initWithName:hashTagCategoryName andHashTagSections:hashTagSections andIsSectionsSortedAlphabetically:isSectionsSortedAlphabetically];
        [hashTagCategories addObject:hashTagsCategory];
        [hashTagsCategory release];
        [hashTagSections release];
    }
    
	return [hashTagCategories autorelease];
}

@end
