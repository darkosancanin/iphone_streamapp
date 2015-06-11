#import <Foundation/Foundation.h>

@interface HashTagsSection : NSObject {
	NSString *name;
	NSArray *hashTagCollections;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *hashTagCollections;

- (id)initWithName:()sectionName andHashTagCollections:(NSArray *)theHashTagCollections;
- (BOOL)hasVisibleName;

@end
