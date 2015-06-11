#import "TweetComposerController.h"
#import "SettingsManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "RefreshManager.h"

@implementation TweetComposerController

@synthesize tweet;

- (id)initWithTweet:(Tweet *)theTweet andTweetComposeType:(TweetComposeType)theTweetComposeType{
    self = [super init];
    if (self) {
        self.tweet = theTweet;
        tweetComposeType = theTweetComposeType;
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        tweetComposeType = TweetComposeTypeCompose;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
    [self setUpNavigationButtons];
    [self setUpTextField];
    [self setUpTextLengthCounter];
    [self setUpScreen];
    [self setUpMessageView];
}

- (void)viewDidAppear:(BOOL)animated{
    [tweetTextView becomeFirstResponder];
}

- (void)setUpScreen{
    if(tweetComposeType == TweetComposeTypeReply){
        self.title = @"Reply";
        tweetTextView.text = [NSString stringWithFormat:@"@%@ ", self.tweet.userName];
    }
    else if(tweetComposeType == TweetComposeTypeQuote){
        self.title = @"New Tweet";
        tweetTextView.text = [NSString stringWithFormat:@"\"@%@: %@\" ", self.tweet.userName, self.tweet.text];
    }
    else if(tweetComposeType == TweetComposeTypeCompose){
        self.title = @"New Tweet";
    }
    
    int tweetTextViewTextLength = [tweetTextView.text length];
    textLengthLabel.text = [NSString stringWithFormat:@"%i", 140 - tweetTextViewTextLength];
    sendButton.enabled = (tweetTextViewTextLength <= 140);
}

- (void)setUpMessageView{
	messageView = [[MessageView alloc] init];
    [self.view addSubview:messageView];
    messageView.frame = CGRectMake(messageView.frame.origin.x, 50, messageView.frame.size.width, messageView.frame.size.height);
}

- (void)setUpTextLengthCounter{
    UIView *textCounterView = [[UIView alloc] initWithFrame:CGRectMake(260, 170, 50, 20)];
    textCounterView.backgroundColor = [UIColor blackColor];
    textCounterView.alpha = ALPHA_LEVEL;
    textCounterView.layer.cornerRadius = 5;
    textLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    textLengthLabel.text = @"140";
    textLengthLabel.font = [UIFont boldSystemFontOfSize:12];
    textLengthLabel.textAlignment = UITextAlignmentCenter;
    [textCounterView addSubview:textLengthLabel];
    [self.view addSubview:textCounterView];
    [textCounterView release];
}

- (void)setUpTextField{
    tweetTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 310, 180)];
    tweetTextView.font = [UIFont systemFontOfSize:[[SettingsManager shared] tweetFontSize]];
    tweetTextView.delegate = self;
    [self.view addSubview:tweetTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    textLengthLabel.text = [NSString stringWithFormat:@"%i", 140 - newLength];
    sendButton.enabled = (newLength <= 140);
    return YES;
}

- (void)setUpNavigationButtons{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonClicked)];
    self.navigationItem.rightBarButtonItem = sendButton;
}

- (void)cancelButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendButtonClicked{
    [self disableButtons];
    [messageView showLoadingMessage:@"Sending..."];
    if(tweetComposeType == TweetComposeTypeReply){
        [tweetsManager createTweet:tweetTextView.text inResponseToTweetID:self.tweet.tweetId];
    }
    else{
        [tweetsManager createTweet:tweetTextView.text inResponseToTweetID:0];
    }
}

- (void)enableButtons{
	if(self.navigationItem.rightBarButtonItem){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    if(self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)disableButtons{
	if(self.navigationItem.rightBarButtonItem){
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if(self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
}

- (void)tweetManagerDidSuccessfullyCreateTweet{
    [self enableButtons];
    [self.navigationController popViewControllerAnimated:YES];
    [[RefreshManager shared] setMyStreamScreenNeedsRefreshing:YES];
}

- (void)tweetManagerRequestFailedWithError:(NSString *)error{
    [self enableButtons];
    [messageView hide];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)dealloc{
    [sendButton release];
    [tweetsManager release];
    [messageView release];
    [tweet release];
    [textLengthLabel release];
    [tweetTextView release];
    [super dealloc];
}

@end
