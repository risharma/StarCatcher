//
//  DetailViewController.m
//  StarCatcher
//
//  Created by Rishabh Sharma on 6/7/14.
//  Copyright (c) 2014 Gracenote. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () {
	NSMutableArray *_celebProgram;
}
//- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        //[self configureView];
		[self lookupCelebProgram:newDetailItem];
		
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
	
	
	//if (self.detailItem) {
	  //  self.detailDescriptionLabel.text = [self.detailItem description];
	//}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//UITableViewController *tableView = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	//[self.navigationController pushViewController:tableView animated:YES];
	
	//UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
	
	
	//self.view = tableView;
	
	
	// Do any additional setup after loading the view, typically from a nib.
	//[self configureView];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) lookupCelebProgram:(NSString *)celebName
{
	NSString* personId = [self fetchPersonId:celebName];
	
	[self fetchProgramId:personId];
}

/**/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _celebProgram.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	NSString *object = _celebProgram[indexPath.row];
	cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[_celebProgram removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
/**/

- (void)fetchProgramId: (NSString*)person
{
	NSString *personId = @"217895";
	NSString *lineupId = @"USA-DITV807-DEFAULT";
	NSString *startDateTime = @"2014-06-09T00:00Z";
	NSString *endDateTime = @"2014-06-10T00:00Z";
	NSString *api_key = @"usq58sy9dmprheajzywj9nxu";
	
    NSString *urlString = [NSString stringWithFormat:@"http://data.tmsapi.com/v1/celebs/%@/airings?lineupId=%@&startDateTime=%@&endDateTime=%@&api_key=%@",
						   personId,
						   lineupId,
						   startDateTime,
						   endDateTime,
						   api_key];
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
													   timeoutInterval:10];
	
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
											   NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
			 _celebProgram = [[NSMutableArray alloc] init];
			 
			 NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
			 NSDictionary *response = [array objectAtIndex:0];
			 
			 for (response in array) {
				 NSDictionary *programArray = [response objectForKey:@"program"];
				 NSArray *channelArray = [response objectForKey:@"channels"];
				 
				 NSString *val = [channelArray objectAtIndex:0];
				 NSString *startTime = [response objectForKey:@"startTime"];
				 NSString *endTime = [response objectForKey:@"endTime"];
				 NSString *titleString = [programArray objectForKey:@"title"];
				 NSString *tmsId = [programArray objectForKey:@"tmsId"];
				 NSLog(titleString);
				 NSLog(startTime);
				 NSLog(endTime);
				 NSLog(tmsId);
				 
				 [_celebProgram addObject:titleString];
			 }
         }
     }];
}

- (NSString*)fetchPersonId:(NSString*)celeb
{
	NSString* tmsPersonId;
	
	NSString *urlString = [NSString stringWithFormat:@"https://c1728512.ipg.web.cddbp.net/webapi/json/1.0/"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	//set headers
	NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"<QUERIES>\
						   <AUTH>\
						   <CLIENT>1728512-54CFDE800B4C64A2A3A5B4D7348BD9AC</CLIENT>\
						   <USER>260174201739282661-FAB7A28D306EE4AA75A9099116625D81</USER>\
						   </AUTH>\
						   <LANG>eng</LANG>\
						   <COUNTRY>usa</COUNTRY>\
						   <QUERY CMD=\"CONTRIBUTOR_SEARCH\">\
						   <MODE>SINGLE_BEST</MODE>\
						   <TEXT TYPE=\"NAME\">%@</TEXT>\
						   <OPTION>\
						   <PARAMETER>SELECT_EXTENDED</PARAMETER>\
						   <VALUE>LINK</VALUE>\
						   </OPTION>\
						   </QUERY>\
						   </QUERIES>",
						   celeb] dataUsingEncoding:NSUTF8StringEncoding]];
	//post
	[request setHTTPBody:postBody];
	
	//get response
	NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[NSError alloc] init];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
		//NSLog(@"Response: %@", result);
		
		//here you get the response
		
		NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:NULL];
		
		NSDictionary *response = [res objectForKey:@"RESPONSE"][0];
		NSDictionary *contributor = [response objectForKey:@"CONTRIBUTOR"][0];
		NSDictionary *externId = [contributor objectForKey:@"XID"][0];
		
		NSString *dataSource = [externId objectForKey:@"DATASOURCE"];
		if ([dataSource isEqualToString:@"tmscontributorid" ]) {
			tmsPersonId = [externId objectForKey:@"VALUE"];
		}
	}
	
	return tmsPersonId;
}

@end
