#import <QuartzCore/QuartzCore.h>
#import "TweetTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
#import "SettingsManager.h"

#define BUBBLE_WIDTH 238
#define TOP_BUBBLE_HEIGHT 30
#define MIDDLE_BUBBLE_HEIGHT 40
#define BOTTOM_BUBBLE_HEIGHT 10
#define TEXT_WIDTH 208
#define SCREEN_NAME_AND_DATE_FONTSIZE 9
#define SCREEN_NAME_AND_DATE_WIDTH 70
#define PROFILE_IMAGE_HEIGHT_WIDTH 48


@implementation TweetTableViewCell

static UIImage *leftTopBubbleImage;
static UIImage *leftMiddleBubbleImage;
static UIImage *leftBottomBubbleImage;
static UIImage *rightTopBubbleImage;
static UIImage *rightMiddleBubbleImage;
static UIImage *rightBottomBubbleImage;

@synthesize alignment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
		CGFloat bubbleAlphaValue = ALPHA_LEVEL;
		
		leftTopBubbleImage = [UIImage imageNamed:@"left_top_bubble.png"];
		leftMiddleBubbleImage = [UIImage imageNamed:@"left_middle_bubble.png"];
		leftBottomBubbleImage = [UIImage imageNamed:@"left_bottom_bubble.png"];
		rightTopBubbleImage = [UIImage imageNamed:@"right_top_bubble.png"];
		rightMiddleBubbleImage = [UIImage imageNamed:@"right_middle_bubble.png"];
		rightBottomBubbleImage = [UIImage imageNamed:@"right_bottom_bubble.png"];
		
        topBubbleImageView = [[UIImageView alloc] initWithImage:leftTopBubbleImage];
		topBubbleImageView.alpha = bubbleAlphaValue;
		[self.contentView addSubview:topBubbleImageView];
		
		middleBubbleImageView = [[UIImageView alloc] initWithImage:leftMiddleBubbleImage];
		middleBubbleImageView.alpha = bubbleAlphaValue;
		[self.contentView addSubview:middleBubbleImageView];
		
		bottomBubbleImageView = [[UIImageView alloc] initWithImage:leftBottomBubbleImage];
		bottomBubbleImageView.alpha = bubbleAlphaValue;
		[self.contentView addSubview:bottomBubbleImageView]; 
		
		fullNameLabel = [[UILabel alloc] init];
		fullNameLabel.backgroundColor = [UIColor clearColor];
		fullNameLabel.textColor = [UIColor whiteColor];
		[self.contentView addSubview:fullNameLabel];
		
		textLabel = [[UILabel alloc] init];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textColor = [UIColor whiteColor];
		textLabel.numberOfLines = 0;
		textLabel.textAlignment = UITextAlignmentLeft;
		[self.contentView addSubview:textLabel];
		
		screenNameLabel = [[UILabel alloc] init];
		screenNameLabel.font = [UIFont systemFontOfSize:SCREEN_NAME_AND_DATE_FONTSIZE];
		screenNameLabel.backgroundColor = [UIColor clearColor];
		screenNameLabel.textColor = [UIColor blackColor];
		screenNameLabel.shadowColor = [UIColor lightGrayColor];
		screenNameLabel.shadowOffset = CGSizeMake(0.3,0.3);
		screenNameLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:screenNameLabel];
		
		dateLabel = [[UILabel alloc] init];
		dateLabel.font = [UIFont systemFontOfSize:SCREEN_NAME_AND_DATE_FONTSIZE];
		dateLabel.backgroundColor = [UIColor clearColor];
		dateLabel.textColor = [UIColor blackColor];
		dateLabel.shadowColor = [UIColor lightGrayColor];
		dateLabel.shadowOffset = CGSizeMake(0.3,0.3);
		dateLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:dateLabel];
		
		profileImageView = [[UIImageView alloc] init];
		profileImageView.layer.cornerRadius = 10.0;
		profileImageView.layer.masksToBounds = YES;
		profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
		profileImageView.layer.borderWidth = 1.0;
		[self.contentView addSubview:profileImageView];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.alignment = TweetTableViewCellAlignmentLeft;
    }
    return self;
}

- (void)setAlignment:(TweetTableViewCellAlignment)newAlignment{
	CGFloat bubbleIndent = 70;
	CGFloat bubbleTopIndent = 5;
	CGFloat labelSpeechSideIndent = 20;
	CGFloat labelNonSpeechSideIndent = 8;
	CGFloat fullNameTopIndent = 16;
	CGFloat textTopIndent = 35;
	CGFloat screenNameTopIndent = 55;
	CGFloat dateTopIndent = 65;
	CGFloat screenNameAndDateIndent = 2;
	CGFloat profileImageTopIndent = 5;
	CGFloat profileImageIndent = 12;
	int textFontSize = [[SettingsManager shared] tweetListFontSize];
    
	if(newAlignment == TweetTableViewCellAlignmentLeft){
		topBubbleImageView.frame = CGRectMake(bubbleIndent, bubbleTopIndent, BUBBLE_WIDTH, TOP_BUBBLE_HEIGHT);
		middleBubbleImageView.frame = CGRectMake(bubbleIndent, bubbleTopIndent + TOP_BUBBLE_HEIGHT, BUBBLE_WIDTH, MIDDLE_BUBBLE_HEIGHT);
		bottomBubbleImageView.frame = CGRectMake(bubbleIndent, bubbleTopIndent + TOP_BUBBLE_HEIGHT + MIDDLE_BUBBLE_HEIGHT, BUBBLE_WIDTH, BOTTOM_BUBBLE_HEIGHT);
		fullNameLabel.frame = CGRectMake(bubbleIndent + labelSpeechSideIndent, fullNameTopIndent, TEXT_WIDTH, textFontSize);
		textLabel.frame = CGRectMake(bubbleIndent + labelSpeechSideIndent, textTopIndent, TEXT_WIDTH, textFontSize);
		screenNameLabel.frame = CGRectMake(screenNameAndDateIndent, screenNameTopIndent, SCREEN_NAME_AND_DATE_WIDTH, SCREEN_NAME_AND_DATE_FONTSIZE);
		profileImageView.frame = CGRectMake(profileImageIndent, profileImageTopIndent, PROFILE_IMAGE_HEIGHT_WIDTH, PROFILE_IMAGE_HEIGHT_WIDTH);
		dateLabel.frame = CGRectMake(screenNameAndDateIndent, dateTopIndent, SCREEN_NAME_AND_DATE_WIDTH, SCREEN_NAME_AND_DATE_FONTSIZE);
		
		topBubbleImageView.image = leftTopBubbleImage;
		middleBubbleImageView.image = leftMiddleBubbleImage;
		bottomBubbleImageView.image = leftBottomBubbleImage;
	}
	else {
		CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
		CGFloat rightBubbleIndent = screenWidth - BUBBLE_WIDTH - bubbleIndent;
		topBubbleImageView.frame = CGRectMake(rightBubbleIndent , bubbleTopIndent, BUBBLE_WIDTH, TOP_BUBBLE_HEIGHT);
		middleBubbleImageView.frame = CGRectMake(rightBubbleIndent, bubbleTopIndent + TOP_BUBBLE_HEIGHT, BUBBLE_WIDTH, MIDDLE_BUBBLE_HEIGHT);
		bottomBubbleImageView.frame = CGRectMake(rightBubbleIndent, bubbleTopIndent + TOP_BUBBLE_HEIGHT + MIDDLE_BUBBLE_HEIGHT, BUBBLE_WIDTH, BOTTOM_BUBBLE_HEIGHT);
		fullNameLabel.frame = CGRectMake(rightBubbleIndent + labelNonSpeechSideIndent, fullNameTopIndent, TEXT_WIDTH, textFontSize);
		textLabel.frame = CGRectMake(rightBubbleIndent + labelNonSpeechSideIndent, textTopIndent, TEXT_WIDTH, textFontSize);
		CGFloat rightScreenNameIndent = screenWidth - SCREEN_NAME_AND_DATE_WIDTH - screenNameAndDateIndent;
		screenNameLabel.frame = CGRectMake(rightScreenNameIndent, screenNameTopIndent, SCREEN_NAME_AND_DATE_WIDTH, SCREEN_NAME_AND_DATE_FONTSIZE);
		CGFloat rightProfileImageIndent = screenWidth - PROFILE_IMAGE_HEIGHT_WIDTH - profileImageIndent;
		profileImageView.frame = CGRectMake(rightProfileImageIndent, profileImageTopIndent, PROFILE_IMAGE_HEIGHT_WIDTH, PROFILE_IMAGE_HEIGHT_WIDTH);
		CGFloat rightDateIndent = screenWidth - SCREEN_NAME_AND_DATE_WIDTH - screenNameAndDateIndent;
		dateLabel.frame = CGRectMake(rightDateIndent, dateTopIndent, SCREEN_NAME_AND_DATE_WIDTH, SCREEN_NAME_AND_DATE_FONTSIZE);
		
		topBubbleImageView.image = rightTopBubbleImage;
		middleBubbleImageView.image = rightMiddleBubbleImage;
		bottomBubbleImageView.image = rightBottomBubbleImage;
	}
}

- (void)setTweet:(Tweet *)newTweet andAlignment:(TweetTableViewCellAlignment)newAlignment{
	if(newTweet != tweet){
		[tweet release];
		tweet = [newTweet retain];
    }
		
    [self setAlignment:newAlignment];
    dateLabel.text = [newTweet createdDateShortFormat];
    screenNameLabel.text = newTweet.userName;
    fullNameLabel.text = [newTweet getFullNameOrUsername];
    textLabel.text = [newTweet formattedText];
    CGFloat textLabelsNewHeight = [self textLabelHeightForText:newTweet.text];
    textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, textLabelsNewHeight);
    middleBubbleImageView.frame = CGRectMake(middleBubbleImageView.frame.origin.x, middleBubbleImageView.frame.origin.y,middleBubbleImageView.frame.size.width, textLabelsNewHeight);
    bottomBubbleImageView.frame = CGRectMake(bottomBubbleImageView.frame.origin.x, middleBubbleImageView.frame.origin.y + middleBubbleImageView.frame.size.height, bottomBubbleImageView.frame.size.width, bottomBubbleImageView.frame.size.height);
		
    [profileImageView setImageWithURL:[NSURL URLWithString:newTweet.profileImageUrl]
					   placeholderImage:[UIImage imageNamed:@"profile_image_placeholder.png"]];
        
    int textFontSize = [[SettingsManager shared] tweetListFontSize];
    fullNameLabel.font = [UIFont boldSystemFontOfSize:textFontSize];
    textLabel.font = [UIFont systemFontOfSize:textFontSize];
}

- (CGFloat) textLabelHeightForText:(NSString *) textToDisplay {
	CGSize maximumLabelSize = CGSizeMake(TEXT_WIDTH ,9999);
	CGSize expectedLabelSize = [textToDisplay sizeWithFont:[UIFont systemFontOfSize:[[SettingsManager shared] tweetListFontSize]]
								constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
	return expectedLabelSize.height;
}

+ (CGFloat) cellHeightForTweet:(Tweet *) tweetToDisplay {
	CGSize maximumLabelSize = CGSizeMake(TEXT_WIDTH ,9999);
	CGSize expectedLabelSize = [tweetToDisplay.text sizeWithFont:[UIFont systemFontOfSize:[[SettingsManager shared] tweetListFontSize]]
										 constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
	CGFloat height = expectedLabelSize.height + 50;
	if(height < 75) height = 75;
	return height;
}

- (void)dealloc {
	[textLabel release];
	[fullNameLabel release];
	[screenNameLabel release];
	[dateLabel release];
	[topBubbleImageView release];
	[middleBubbleImageView release];
	[bottomBubbleImageView release];
	[profileImageView release];
	[tweet release];
    [super dealloc];
}


@end

