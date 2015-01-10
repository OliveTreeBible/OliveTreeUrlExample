Olive Tree Url Examples
=======================

Olive Tree Bible Software supports a custom URL scheme, `olivetree://bible/`, to open the app to specific passages.  The URL format looks like this:

    olivetree://bible/<book>.<chapter>.<verse>
    
Alternatively, you can put an encoded space (`%20`) between the book, chapter, and verse:

    olivetree://bible/<book>%20<chapter>%20<verse>
    
Book names are case-insensitive. If there is a space in the book name, like 1 Corinthians or 3 John, you need to encode that space as `%20`.
    
Some example links:

- `olivetree://bible/romans.8.28` or `olivetree://bible/romans%208%2028` for Romans 8:28
- `olivetree://bible/1%20corinthians.13.1` or `olivetree://bible/1%20corinthians%2013%201` for 1 Corinthians 13:1

In version 5.9.12 of Olive Tree on iOS, we also added support for specifying the book as a number (1 for Genesis, 40 for Matthew, etc). Then John 3:16 would be `olivetree://bible/43.3.16`. As of January 2015, almost 80% of our iOS users are on 5.9.12 or later.

Here's how you would write a hyperlink in HTML that would open Olive Tree on iOS:

    <a href='olivetree://43.3.16'>This opens John 3:16</a>

iOS
===================

See the example project for a demonstration of how to open an Olive Tree app on iOS to a specific verse reference from another app.  The relevant code is in `tableView:didSelectRowAtIndexPath:` in `OTViewController`.  In summary:

```objective-c
NSString *reference @"2 Corinthians 3:18"; //example reference
NSString *urlBase = @"olivetree://bible/";
// The final URL will be olivetree://bible/2%20Corinthians%203.18

//Replace spaces with percent escape
reference = [reference stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

//Replace colon with period
reference = [reference stringByReplacingOccurrencesOfString:@":" withString:@"."];

//Create the URL, check if it can be opened (i.e. if an Olive Tree app is available), and open it
NSString *strURL = [NSString stringWithFormat:@"%@%@", urlBase, reference];
if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strURL]])
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
```
