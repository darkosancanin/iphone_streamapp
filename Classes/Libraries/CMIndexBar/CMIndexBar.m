//
//  CMIndexBar.m
//
//  Created by Craig Merchant on 07/04/2011.
//

#import "CMIndexBar.h"

@implementation CMIndexBar

@synthesize delegate;
@synthesize highlightedBackgroundColor;
@synthesize textColor;

- (id)init {
    self = [super init];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.textColor = [UIColor blackColor];
		self.highlightedBackgroundColor = [UIColor lightGrayColor];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor blackColor];
		self.highlightedBackgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutSubviews 
{
	[super layoutSubviews];	

	int i=0;
	int subcount=0;
	
	for (UIView *subview in self.subviews) 
	{
		if ([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UIImageView class]]) 
		{
			subcount++;
		}
	}
	
	for (UIView *subview in self.subviews) 
	{
		if ([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UIImageView class]]) 
		{
			float ypos;
			
			if(i == 0)
			{
				ypos = 0;
			}
			else if(i == subcount-1)
			{
				ypos = self.frame.size.height-24.0;
			}
			else
			{
				float sectionheight = ((self.frame.size.height-24.0)/subcount);
				
				sectionheight = sectionheight+(sectionheight/subcount);
				
				ypos = (sectionheight*i);
			}
			
			[subview setFrame:CGRectMake(0, ypos, self.frame.size.width, 24.0)];
			
			i++;
		}
	}
}

- (void) setIndexes:(NSArray*)indexes withCategoriesIndex:(BOOL)showCategoriesIndex
{	
	[self clearIndex];
    
    categoriesIndexIsVisible = showCategoriesIndex;
    NSUInteger indexCount = [indexes count];
    if(categoriesIndexIsVisible) indexCount++;
	
	int i;
	
	for (i=0; i<indexCount; i++)
	{
		float ypos;
		
		if(i == 0)
		{
			ypos = 0;
		}
		else if(i == indexCount-1)
		{
			ypos = self.frame.size.height-24.0;
		}
		else
		{
			float sectionheight = ((self.frame.size.height-24.0)/indexCount);			
			sectionheight = sectionheight+(sectionheight/indexCount);
			
			ypos = (sectionheight*i);
		}
		
        if(categoriesIndexIsVisible && i == 0){
            UIImageView *categoriesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categories.png"]];
            categoriesImageView.frame = CGRectMake(0, ypos, self.frame.size.width, 24.0);
            [self addSubview:categoriesImageView];
            [categoriesImageView release];
        }
        else{
            UILabel *alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ypos, self.frame.size.width, 24.0)];
            alphaLabel.textAlignment = UITextAlignmentCenter;
            int objectIndexNumber = i;
            if(categoriesIndexIsVisible) objectIndexNumber = i-1;
            alphaLabel.text = [indexes objectAtIndex:objectIndexNumber];
            alphaLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];	
            alphaLabel.backgroundColor = [UIColor clearColor];
            alphaLabel.textColor = textColor;
            [self addSubview:alphaLabel];	
            [alphaLabel release];
        }
	}
}

- (void) clearIndex
{
	for (UIView *subview in self.subviews) 
	{
		[subview removeFromSuperview];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
    
    for (UILabel *label in self.subviews) 
	{
		if ([label isKindOfClass:[UILabel class]]) 
		{
            label.textColor = [UIColor blackColor];
        }
    }

	UIView *backgroundView = (UIView*)[self viewWithTag:767];
	[backgroundView removeFromSuperview];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
    
    for (UILabel *label in self.subviews) 
	{
		if ([label isKindOfClass:[UILabel class]]) 
		{
            label.textColor = [UIColor whiteColor];
        }
    }
	
	UIView *backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
	[backgroundview setBackgroundColor:highlightedBackgroundColor];
	backgroundview.layer.cornerRadius = self.bounds.size.width/2;
	backgroundview.layer.masksToBounds = YES;
	backgroundview.tag = 767;
	[self addSubview:backgroundview];
	[self sendSubviewToBack:backgroundview];
	[backgroundview release];
	
    if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];

	if(touchPoint.x < 0)
	{
		return;
	}
	
	int count=0;
	
	for (UIView *subview in self.subviews) 
	{
		if ([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UIImageView class]]) 
		{
			if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height)
			{
				count++;
				break;
			}
			
			count++;
		}
	}
	
    if(categoriesIndexIsVisible && count == 1){
        [delegate didSelectCategoriesIndex];
    }
    else if(categoriesIndexIsVisible){
        [delegate indexSelectionDidChange:self:count-2];
    }
    else{
        [delegate indexSelectionDidChange:self:count-1];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

	if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	
	if(touchPoint.x < 0)
	{
		return;
	}
	
	int count=0;
	
	for (UIView *subview in self.subviews) 
	{
		if ([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UIImageView class]])  
		{
			if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height)
			{
				count++;
				break;
			}
			
			count++;
		}
	}
	
	if(categoriesIndexIsVisible && count == 1){
        [delegate didSelectCategoriesIndex];
    }
    else if(categoriesIndexIsVisible){
        [delegate indexSelectionDidChange:self:count-2];
    }
    else{
        [delegate indexSelectionDidChange:self:count-1];
    }
}

@end
