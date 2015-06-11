#import <Foundation/Foundation.h>

@interface HashTagCollection : NSObject {
	NSString *name;
	NSArray *hashTags;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *shortName;
@property (nonatomic, retain) NSArray *hashTags;

- (id)initWithName:()hashTagCollectionName andShortName:(NSString *)hashTagCollectionShortName andHashTags:(NSArray *)theHashTags;

@end
