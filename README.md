Olive Tree Url Examples
===================

iOS
===================

This is an example project demonstrating how to use the `olivetree://bible/` URL scheme to open an Olive Tree app on iOS to a specific verse reference.  The relevant code is in `tableView:didSelectRowAtIndexPath:` in `OTViewController`.  In summary:

```objective-c
NSString *reference @"2 Corinthians 3:18"; //example reference
NSString *urlBase = @"olivetree://bible/";

//Replace spaces with percent escape
reference = [reference stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

//Replace colon with period
reference = [reference stringByReplacingOccurrencesOfString:@":" withString:@"."];

//Create the URL, check if it can be opened (i.e. if an Olive Tree app is available), and open it
NSString *strURL = [NSString stringWithFormat:@"%@%@", urlBase, reference];
if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strURL]])
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
```