//
//  HKConnection.m
//  RestConnection
//
//  Created by Hubert Kunnemeyer on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKConnection.h"

@implementation HKConnection
@synthesize callBackBlock,requestdata,HUD;

- (id)initWithCallbackBlock:(HKConnectionBlock)block{
     self = [super init];
    if (!self) {
        return nil;
    }

    self.callBackBlock = block;
    self.requestdata = [NSMutableData data];
    

    return self;
}

- (id)initWithURL:(NSURL*)URL progressHudView:(UIView*)HUDdisplayView callback:(HKConnectionBlock)block{
    self = [super init];
    if (!self) {
        return nil;
    }
    

    self.callBackBlock = block;
    
    [self sendRequest:URL view:HUDdisplayView];
    
    return self;
}
- (void)sendRequest:(NSURL*)URL view:(UIView*)viewForHUD{
    self.requestdata = [NSMutableData data];

    HUD = [MBProgressHUD showHUDAddedTo:viewForHUD animated:YES];
    HUD.labelText = @"Connecting";
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
     NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
   
    [connection start];
    
}


#pragma -mark
#pragma mark NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.requestdata appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [HUD hide:YES];
    self.callBackBlock(self.requestdata,nil);



}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [HUD hide:YES];

     NSLog(@"ERROR Desription:%@\nREASON:%@\nRECOVERY SUGGESTION:%@",[error localizedDescription],[error localizedFailureReason],[error localizedRecoverySuggestion]);
        self.callBackBlock(nil,error);

   

}

- (void)hudWasHidden {
    // Remove HUD from screen 
    [HUD removeFromSuperview];
    
    // add here the code you may need
    
}












@end
