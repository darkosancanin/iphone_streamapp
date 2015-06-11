#import <Foundation/Foundation.h>

@interface HashTagsCategory : NSObject {
	NSString *name;
	NSArray *hashTagSections;
    BOOL isStreamSectionsSortedAlphabetically;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *hashTagSections;
@property (nonatomic) BOOL isSectionsSortedAlphabetically;

- (id)initWithName:()sectionName andHashTagSections:(NSArray *)theHashTagSections andIsSectionsSortedAlphabetically:(BOOL)isHashTagsSectionsSortedAlphabetically;

@end
