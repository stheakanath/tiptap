#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Usage Example:
    [self executeTransfer:@20 medium:@"balance" fromAccountID:@"56241a14de4bf40b17112f54" toAccountID:@"56241a14de4bf40b17112f57" apiKey:@"3bdaaa3c82010b88c585c1e966c8d6f8"];
    //[self getAllTransfers:@"56241a14de4bf40b17112f54" apiKey:@"3bdaaa3c82010b88c585c1e966c8d6f8"];

}

/*
 * Executes a transfer using the Nessi API 
 */
- (void)executeTransfer:(NSNumber*)amount medium:(NSString*)medium fromAccountID:(NSString*)fromAccountID toAccountID:(NSString*)toAccountID apiKey:(NSString*)apiKey {
    
    //Get Transaction Timestamp
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy hh:mm:ss"];

    //Create JSON
    NSDictionary *dictionary = @{ @"medium" : medium, @"payee_id": toAccountID,
                                  @"amount": amount, @"transaction_date": [dateFormatter stringFromDate:[NSDate date]]};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    //Create default configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //Create NSURL
    NSString * urlString = [NSString stringWithFormat:@"http://api.reimaginebanking.com/accounts/%@/transfers?key=%@", fromAccountID, apiKey];
    NSURL * url = [NSURL URLWithString:urlString];
    
    //Create url Request
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //Create SessionDataTask
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                           }
                                                           
                                                       }];
    //Run Request
    [dataTask resume];
}

- (void) getAllTransfers: (NSString*)accountID apiKey:(NSString*)apiKey {
    //Create default configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //Create NSURL
    NSString * urlString = [NSString stringWithFormat:@"http://api.reimaginebanking.com/accounts/%@/transfers?key=%@", accountID, apiKey];
    NSURL * url = [NSURL URLWithString:urlString];
    
    //Create url Request
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    //Create SessionDataTask
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                           }
                                                           
                                                       }];
    //Run Request
    [dataTask resume];


}

- (IBAction)createLabel {  //create label on button click
    
    UILabel *label = [[UILabel alloc] init];
    
    [label sizeToFit]; //set width and height of label based on text size
    
    //position label
    CGRect frame = label.frame;
    frame.origin = CGPointMake(50, 50);
    label.frame = frame;
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = @"This is where the text goes";
    
    [self.view addSubview:label];     //add label to view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
