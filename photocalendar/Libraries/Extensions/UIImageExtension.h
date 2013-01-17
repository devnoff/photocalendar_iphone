//UIImageExtension.h
@interface UIImage (UIImageExtension)
+ (UIImage *)imageNamed:(NSString *)name forSession:(id)session;
+ (UIImage *)imageFilePath:(NSString *)path forSession:(id)session ;
+ (void)clearSession:(id)session;
@end