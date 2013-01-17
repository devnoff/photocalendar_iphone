/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
//#import "AnniversaryDBAdapter.h"
//#import "DDay.h"
@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 45.f;
static const CGFloat kMonthLabelHeight = 17.f;
static const CGFloat kNavigationHeight = 44.f;

@implementation KalView

@synthesize delegate, tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
  if ((self = [super initWithFrame:frame])) {
    delegate = theDelegate;
    logic = [theLogic retain];
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	  
//	UIView * navigationView= [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kNavigationHeight)] autorelease];
//
//	[self addSubviewsTonNvigationHeader:navigationView];
//	[self addSubview:navigationView];
	  
      
	  
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0, frame.size.width, kHeaderHeight)] autorelease];
    //headerView.backgroundColor = [UIColor blueColor];
    [self addSubviewsToHeaderView:headerView];
    [self addSubview:headerView];
    
    UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height )] autorelease];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}

- (void)addSubviewsTonNvigationHeader:(UIView *)navigationView{

	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavBg.png"]];
    CGRect imageFrame = navigationView.frame;
	imageFrame.origin = CGPointZero;
	backgroundView.frame = imageFrame;
	[navigationView addSubview:backgroundView];
	[backgroundView release];
	
	CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (200/2.0f),
										0,
										200,
										44);
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.text = NSLocalizedString(@"calendar",@"calendar");
	titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:20.f];
	titleLabel.shadowColor = [UIColor colorWithRed:139.f/255.f green:28.f/255.f blue:19.f/255.f alpha:1];
	
	[navigationView addSubview:titleLabel];
	[titleLabel release];
	
	CGRect addButtonFrame = CGRectMake(self.width - 36,
                                       0,
                                       33,
                                       44);
	UIButton *addButton = [[UIButton alloc] initWithFrame:addButtonFrame];
	[addButton setImage:[UIImage imageNamed:@"HomeNavBtnAdd.png"] forState:UIControlStateNormal];
	addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	addButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	addButton.showsTouchWhenHighlighted = YES;
	
	
    
	[addButton addTarget:self action:@selector(addEvent) forControlEvents:UIControlEventTouchUpInside];
	
	CGRect todayButtonFrame = CGRectMake(5,
                                         7,
                                         51,
                                         30);
	UIButton *todayButton = [[UIButton alloc] initWithFrame:todayButtonFrame];
	[todayButton addTarget:self action:@selector(showAndSelectToday) forControlEvents:UIControlEventTouchUpInside];
	[todayButton setImage:[UIImage imageNamed:@"BtnSubmit.png"] forState:UIControlStateNormal];
	[todayButton setImage:[UIImage imageNamed:@"BtnSubmit.On.png"] forState:UIControlStateHighlighted];
	todayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	todayButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	UILabel *todayLabel = [[UILabel alloc] initWithFrame:todayButtonFrame];
	todayLabel.text = NSLocalizedString(@"today",@"today");
	todayLabel.textColor = [UIColor whiteColor];
	todayLabel.textAlignment = UITextAlignmentCenter;
	todayLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	todayLabel.backgroundColor = [UIColor clearColor];
	[navigationView addSubview:addButton];
	[navigationView addSubview:todayButton];
	[navigationView addSubview:todayLabel];
	[addButton release];
    [todayLabel release];
    [todayButton release];
	
}
- (void)showAndSelectToday
{
	[delegate showAndSelectDate:[NSDate date]];
}

-(void)addEvent{
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//		if (!PROVERSION && ![defaults boolForKey:@"isBought"]) {
//			AnniversaryDBAdapter * dbAdapter = [[AnniversaryDBAdapter alloc] init];
//			[dbAdapter open];
//			int count = [dbAdapter selectQueryCount];
//			[dbAdapter close];
//			[dbAdapter release];
//			if (count >11) {
//				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"update_message",@"update_message") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",@"cancel") otherButtonTitles:NSLocalizedString(@"confirm",@"confirm"),nil];
//				[alert show];
//				[alert release];
//				return;
//			}
//		}
//	CSDate *csDate = [[CSDate alloc] initWithYear:[[self selectedDate] year] month:[[self selectedDate]  month] day:[[self selectedDate]  day]];
//    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:  csDate,@"anniversarydate",nil];
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"addAnniversaryNotification" object:dic userInfo:nil];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"upgradeAppNotification" object:nil userInfo:nil];
	}
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
  const CGFloat kChangeMonthButtonWidth = 46.0f;
  const CGFloat kChangeMonthButtonHeight = 30.0f;
  const CGFloat kMonthLabelWidth = 200.0f;
  const CGFloat kHeaderVerticalAdjust = 3.f;
  
  // Header background gradient
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Kal.bundle/kal_jh_header"]];
  CGRect imageFrame = headerView.frame;
  imageFrame.origin = CGPointZero;
  backgroundView.frame = imageFrame;
  [headerView addSubview:backgroundView];
  [backgroundView release];
  
  // Create the previous month button on the left side of the view
  CGRect previousMonthButtonFrame = CGRectMake(self.left,
                                               kHeaderVerticalAdjust,
                                               kChangeMonthButtonWidth,
                                               kChangeMonthButtonHeight);
  UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
  [previousMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_left_arrow.png"] forState:UIControlStateNormal];
  previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:previousMonthButton];
  [previousMonthButton release];
  
  // Draw the selected month name centered and at the top of the view
  CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (kMonthLabelWidth/2.0f),
                                      kHeaderVerticalAdjust,
                                      kMonthLabelWidth,
                                      kMonthLabelHeight);
  headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
  headerTitleLabel.backgroundColor = [UIColor clearColor];
  headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f];
  headerTitleLabel.textAlignment = UITextAlignmentCenter;
  headerTitleLabel.textColor = [UIColor whiteColor];
    headerTitleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:.25];
  headerTitleLabel.shadowOffset = CGSizeMake(0.f, -1);
    headerTitleLabel.alpha = 1.0f;
  [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
  [headerView addSubview:headerTitleLabel];
    

    UILabel * tapLabel = [[[UILabel alloc] initWithFrame:headerTitleLabel.frame] autorelease];
    tapLabel.text = @"Tap to Today";
    tapLabel.minimumFontSize = 10.f;
    tapLabel.adjustsFontSizeToFitWidth = YES;
    tapLabel.font = [UIFont boldSystemFontOfSize:20.f];
    tapLabel.lineBreakMode = UILineBreakModeWordWrap;
    tapLabel.backgroundColor = [UIColor clearColor];
    tapLabel.textAlignment = UITextAlignmentCenter;
    tapLabel.textColor = [UIColor whiteColor];
    tapLabel.shadowColor = [UIColor colorWithWhite:0 alpha:.25];
    tapLabel.shadowOffset = CGSizeMake(0.f, -1);
    tapLabel.alpha = 0.0f;
    [headerView addSubview:tapLabel];
    
    
    [UIView animateWithDuration:1 
                     animations:^{
                         headerTitleLabel.alpha = 0.0f;
                         tapLabel.alpha = 1.0f;
                     } 
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1 
                                          animations:^{
                                              headerTitleLabel.alpha = 1.0f;
                                              tapLabel.alpha = 0.0f;
                                          } 
                                          completion:^(BOOL finished){
                                              [tapLabel removeFromSuperview];
                                          }];
                     }];
    
    
    
    
    
    UIButton * todayBtn = [[UIButton alloc] initWithFrame:monthLabelFrame];
    [todayBtn addTarget:self action:@selector(showAndSelectToday) forControlEvents:UIControlEventTouchDown];
    [todayBtn setBackgroundColor:[UIColor clearColor]];
    [todayBtn setShowsTouchWhenHighlighted:YES];
    [headerView addSubview:todayBtn];
    [todayBtn release];
    
    
    
    
    
    
//    UIButton * titleBtn = [[UIButton alloc]initWithFrame:monthLabelFrame];
//    [titleBtn addTarget:self action:@selector(showAndSelectToday) forControlEvents:UIControlEventTouchDown];
//    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [titleBtn setBackgroundColor:[UIColor clearColor]];
//    [headerView addSubview: titleBtn];
//    [titleBtn release];
  
  // Create the next month button on the right side of the view
  CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth,
                                           kHeaderVerticalAdjust,
                                           kChangeMonthButtonWidth,
                                           kChangeMonthButtonHeight);
  UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
  [nextMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_right_arrow.png"] forState:UIControlStateNormal];
  nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:nextMonthButton];
  [nextMonthButton release];
  
  // Add column labels for each weekday (adjusting based on the current locale's first weekday)
  NSArray *weekdayNames = [[[[NSDateFormatter alloc] init] autorelease] shortWeekdaySymbols];
  NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
  NSUInteger i = firstWeekday - 1;
  for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f, i = (i+1)%7) {
    CGRect weekdayFrame = CGRectMake(xOffset, 30.f, 46.f, kHeaderHeight - 29.f);
    UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
    weekdayLabel.backgroundColor = [UIColor clearColor];
    weekdayLabel.font = [UIFont boldSystemFontOfSize:10.f];
    weekdayLabel.textAlignment = UITextAlignmentCenter;
    weekdayLabel.textColor = RGB(151, 151, 151);
    weekdayLabel.shadowColor = [UIColor colorWithWhite:0 alpha:.25];
    weekdayLabel.shadowOffset = CGSizeMake(0.f, -1);
    weekdayLabel.text = [weekdayNames objectAtIndex:i];
    [headerView addSubview:weekdayLabel];
    [weekdayLabel release];
  }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
    // Both the tile grid and the list of events will automatically lay themselves
    // out to fit the # of weeks in the currently displayed month.
    // So the only part of the frame that we need to specify is the width.
    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);
    
    // The tile grid (the calendar body)
    gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
    [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [contentView addSubview:gridView];
    
    // The list of events for the selected day
    tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[tableView setRowHeight:50.f];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [contentView addSubview:tableView];
    [tableView sizeToFit];
    
    // Drop shadow below tile grid and over the list of events for the selected day
    shadowView = [[UIImageView alloc] initWithFrame:fullWidthAutomaticLayoutFrame];
    shadowView.image = [UIImage imageNamed:@"Kal.bundle/kal_grid_shadow"];
    shadowView.height = shadowView.image.size.height;
    [contentView addSubview:shadowView];
    
    // Trigger the initial KVO update to finish the contentView layout
    [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    
    /* Animate tableView filling the remaining space after the
     * gridView expanded or contracted to fit the # of weeks
     * for the month that is being displayed.
     *
     * This observer method will be called when gridView's height
     * changes, which we know to occur inside a Core Animation
     * transaction. Hence, when I set the "frame" property on
     * tableView here, I do not need to wrap it in a
     * [UIView beginAnimations:context:].
     */
    CGFloat gridBottom = gridView.top + gridView.height;
    CGRect frame = tableView.frame;
    frame.origin.y = gridBottom;
    frame.size.height = tableView.superview.height - gridView.height - 48;
    tableView.frame = frame;
    shadowView.top = gridBottom;
    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (void)selectDate:(KalDate *)date { [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return gridView.selectedDate; }

- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  [logic release];
  
  [headerTitleLabel release];
  [gridView removeObserver:self forKeyPath:@"frame"];
  [gridView release];
  [tableView release];
  [shadowView release];
  [super dealloc];
}

@end
