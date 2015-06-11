#import <Foundation/Foundation.h>

@interface StreamCategory : NSObject {
	NSString *name;
	NSArray *streamSections;
    BOOL isSectionsSortedAlphabetically;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *streamSections;
@property (nonatomic) BOOL isSectionsSortedAlphabetically;

- (id)initWithName:()categoryName andStreamSections:(NSArray *)theStreamSections andIsSectionsSortedAlphabetically:(BOOL)isStreamSectionsSortedAlphabetically;

@end
