Olive Tree Custom Url Scheme Examples
=======================

Olive Tree Bible Software supports a custom URL scheme.

## Reference

To open the OliveTree app to a specific passage, the URL format looks like this:

    olivetree://bible/<book>.<chapter>.<verse>[/<version>]

Alternatively, you can put an encoded space (`%20`) between the book, chapter, and verse:

    olivetree://bible/<book>%20<chapter>%20<verse>

Book names are case-insensitive. If there is a space in the book name, like 1 Corinthians or 3 John, you need to encode that space as `%20`.

Example reference links:

- `olivetree://bible/romans.8.28` or `olivetree://bible/romans%208%2028` for Romans 8:28
- `olivetree://bible/1%20corinthians.13.1` or `olivetree://bible/1%20corinthians%2013%201` for 1 Corinthians 13:1

In version 5.9.12 of Olive Tree on iOS, we also added support for specifying the book as a number (1 for Genesis, 40 for Matthew, etc). Then John 3:16 would be `olivetree://bible/43.3.16`, which is shorter, neater, and avoids spelling issues. As of June 2015, almost 90% of our iOS users are on 5.9.12 or later.

Here's how you would write a hyperlink in HTML that would open Olive Tree on iOS:

    <a href='olivetree://bible/43.3.16'>This opens John 3:16</a>

## Search

You can search for term(s) in a specific product by doing the following:

    `olivetree://search/<search term(s)>[/<product ID, title, or abbreviated title>]`

Example search links to search current Bible or other product or specific product:

- `olivetree://search/love`
- `olivetree://search/god@20loved/nkjv`

_Note: Search links only work on iOS._

## Lookup

To lookup across any enhanced Bible dictionaries you may have downloaded, tags, notes, saved passages, etc., do the following:

Lookup term(s) across all products by doing the following:

    `olivetree://lookup/<lookup term>`

Example lookup link:

- `olivetree://lookup/love`
- `olivetree://lookup/god@20loved`

_Note: Lookup links only work on iOS_

## Reading Plan

Open your default or last-used reading plan by doing the following:

    `olivetree://startplan`

_Note: Reading plan links only work on iOS._

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
