#import "InfoController.h"
#import "Button.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "ApplicationSettings.h"
#import "WebViewController.h"

@implementation InfoController

@synthesize headerView, textViewBackground;

- (void)viewDidLoad{
	[super viewDidLoad];
    [self setUpViews];
}

- (void)setUpViews{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    self.view = scrollView;
    [scrollView release];
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.contentOffset = CGPointMake(0, 0);
    [scrollView setContentSize:CGSizeMake(320, 530)];
    
    UIView *headingBackground = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)];
    headingBackground.backgroundColor = [UIColor blackColor];
    headingBackground.layer.cornerRadius = 10.0;
    headingBackground.alpha = ALPHA_LEVEL;
    [scrollView addSubview:headingBackground];
    [headingBackground release];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 53, 130, 20)];
    copyrightLabel.text = @"© 2011 Darko Sancanin";
    copyrightLabel.font = [UIFont systemFontOfSize:12];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    copyrightLabel.textColor = [UIColor whiteColor];
    [headingBackground addSubview:copyrightLabel];
    [copyrightLabel release];
    
    UIImageView *headingView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 280, 45)];
    headingView.image = [UIImage imageNamed:@"info_heading.png"];
    [headingBackground addSubview:headingView];
    [headingView release];
    
    UIView *textBackground = [[UIView alloc] initWithFrame:CGRectMake(10, 107, 300, 290)];
    textBackground.backgroundColor = [UIColor blackColor];
    textBackground.layer.cornerRadius = 10.0;
    textBackground.alpha = ALPHA_LEVEL;
    [scrollView addSubview:textBackground];
    [textBackground release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 280, 260)];
    textView.userInteractionEnabled = NO;
    textView.text = DESCRIPTION;
    textView.font = [UIFont systemFontOfSize:14];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
    textView.scrollEnabled = NO;
    [textBackground addSubview:textView];
    [textView release];

    [self addButtons];
}

- (void)addButtons{
    Button *sendEmailButton = [[Button alloc] initWithFrame:CGRectMake(10, 415, 300, 45) andTitle:EMAIL_ADDRESS];
    sendEmailButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [sendEmailButton addTarget:self action:@selector(sendEmailButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendEmailButton];
    [sendEmailButton release];
    
    Button *websiteButton = [[Button alloc] initWithFrame:CGRectMake(10, 470, 300, 45) andTitle:WEB_ADDRESS];
    websiteButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [websiteButton addTarget:self action:@selector(websiteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:websiteButton];
    [websiteButton release];
}

- (void)websiteButtonClicked{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:WEB_ADDRESS]];
    WebViewController *webViewController = [[WebViewController alloc] initWithUrlRequest:urlRequest];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

- (void)sendEmailButtonClicked{
    MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
    emailController.mailComposeDelegate = self;
    [emailController setSubject:APPLICATION_NAME];
    [emailController setToRecipients:[NSArray arrayWithObject:EMAIL_ADDRESS]];
    [self presentModalViewController:emailController animated:YES];
    [emailController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [textViewBackground release];
    [headerView release];
    [super dealloc];
}

@end
