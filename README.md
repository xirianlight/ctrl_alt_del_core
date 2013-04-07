ctrl_alt_del_core
=================

First stage of ctrl_alt_del group project
This project was the foundation of what would become Wi-Where, a location based, visual browsing app.

The primary functionality being tested here was being able to run a search query through Flickr for some results, then show a user nearby Yelp venues to the taken picture. That functionality is in place.

In the original build, photos were viewed in a tableView along the bottom of the first screen, their location annotated in the above mapView. On the second screen, after selecting an image, you see the venues.

This piece of the core was abandoned for a different code-base before further work could be done, which is why, at this point, the detail disclosure button in the second view controller doesn't perform any actions.

All the back buttons are unwind segues in order to preserve previous states without delving too deeply into persistence.  To see where this project ended up, check out
https://github.com/gBit/thePeanutGallery

Thanks!
