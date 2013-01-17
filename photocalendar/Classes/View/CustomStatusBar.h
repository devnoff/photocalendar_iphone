@interface CustomStatusBar : UIWindow
{
@private
	
    // Syncing Box
    UIView *_syncView;
    
    
    // Complete Box
    UIView *_compView;

    
    CGRect showingFrame;
    CGRect hidingFrame;
    
}
-(void)start;
-(void)finish;
-(void)updateCurrentProcess:(NSString*)percent;

@end